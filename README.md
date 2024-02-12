# Event Processing Service: The Application to process events from various services like Stripe.

## Problem Statement

A simple rails application that receives and processes events from Stripe.

Acceptance criteria:
1. Creating a subscription on stripe.com (via subscription UI) creates a simple
subscription record in the database.
2. The initial state of the subscription record should be 'unpaid'.
paying the first invoice of the subscription changes the state of the local
subscription record from 'unpaid' to 'paid'.
3. Canceling a subscription changes the state of your subscription record to “canceled”
only subscriptions in the state “paid” can be canceled.

## Local Development Setup

### Requirements

- Ruby, Rails, Sidekiq, Redis
- Install redis in your local using https://redis.io/docs/install/install-redis/install-redis-on-mac-os/ and start the redis server

```sh
brew install redis
redis-server
```

After cloning the repo, the basic setup commands are:

```sh
cd event_processing_service
bundle install
add the stripe account secret keys, webhook secrets to credentials file using:
	bundle exec rails credentials:edit
	Add values in credentials file in the below format:
	stripe:
		webhook_secrets: <your wh_... value>
		secret_key: <your secret key value from stripe API keys>
		signing_secret: <your signing secret value from stripe>
bin/setup
bin/dev
```

bin/setup, bin/dev:
	This script is used to start the development environment for a Ruby application. It sets up the environment and runs the necessary processes defined in the Procfile using Foreman(gem). Used foreman gem so that its easy to spin up both rails server and sidekiq server and also setup the db.

### Database Deisgn

stripe_webhook_events: 
	This table stores webhook events received from Stripe. It includes columns for the event data (data), state of the event (state), external ID (external_id), processing errors (processing_errors), timestamp of creation (created_at) and update (updated_at), and the type of event (event_type).

subscriptions: 
	This table stores information about subscriptions. It includes columns for the Stripe ID of the subscription (stripe_id), state of the subscription (state), timestamp of creation (created_at) and update (updated_at).

Additionally thoughts: We can define indexes  on the stripe_webhook_events table for external_id and event_type, and on the subscriptions table for stripe_id. These indexes can help improve query performance when searching or filtering data based on these columns. For the scope of this project have not added indexes.

### Testing the endpoint with stripe-cli

Endpoint exposed: http://localhost:3000/webhooks/stripe to listen to the given stripe webhook events

1. Register a free Stripe account. https://dashboard.stripe.com/login to get the developer API keys.
	1. Subscription UI to create a subscription and pay the invoice
		Use test mode account in Stripe and simulate the events from the UI
	2. Stripe CLI to listen to events triggered by Stripe on your local machine Stripe
		Webhooks
		https://stripe.com/docs/billing/subscriptions/webhooks 
		Follow the steps in the document and forward the webhooks to local endpoint exposed above
		https://stripe.com/docs/cli/listen

2. Add your secret key to the application credentials file.
3. Install stripe-cli and listen to stripe webhook events and forward the same to our API endpoint.
4. Run the redis-server.
5. Run the rails server, sidekiq server for bg processing using bin/setup.
6. From UI create subscription without paying the invoice immedietly on subscription creation, this sends an event to app and adds a subscription entry with unpaid state. Also adds an entry in stripe webhook evnets table that with processed state.
7. From invoices page, 'Charge Customer' for the invoice that got created for our subscription. This sends invoice.payment_succeeded to our app and changes the state of the unpaid subscription to paid.
8. Cancel this subscription which sends corresponding event and changes the state as mentioned in problem statement to canceled.
9. We can also simulate the same with -> stripe trigger ;customer.subscription.created' from the cli.


### Assumptions done during implementation in the scope of this project/ Project Structure

Have exposed an endpoint http://localhost:3000/webhooks/stripe in the api only application spun up to listen to the given stripe webhook events, designed and developed with the Webhook best practices mentioned in the Stripe Document - https://stripe.com/docs/webhooks#best-practices

1. The db deisgn is simple and have kept the subscription table minimal with only two columns stripe_id and state, as the only use case that we are trying to solve at the moment is to chnage the state of a particular subscription. We can extend this table to have customer information or any other information and have associations as a future scope.
2. Events that are used for the scenarios mentioned in Acceptence criteria are: customer.subscription.created, customer.subscription.deleted and for first time payment for an invoice in a asubscription as invoice.payment_succeeded. If the event needs to be changed can be easily done.
3. The endpoint does not process the request if there are JSONErrors or SignatureVerificationError in the request that comes from the stripe webhook and returns 4xx.
4. Once the verification is done, we first check for the events, if it's an event type that we actually want to process in our application, else no action is taken and goes on to processing the next request. ( For now we are storing this in a constant file, if this list gets bigger we can add a logic in event_handlers -> factory and do the check as a future scope )
5. If the event received is any of the events we support, we send the request to be processed to sidekiq worker in the background and immedietly respond with a status 202 accepted to stripe. Since we send only the required events, its made sure that we don't add extra burden to the workers or store unecessary data in redis.
6. Used event_handlers -> factory to identify the service that needs to be used for processing of the particular event.
7. Have divided the processing of different events into service classes which can be reused anywhere thorught the codebase and provides a proper logical separation between the processing logic. As future scope this code can be reorganised a bit by adding subscription folder and making it a module which can have creation service, deletion service and other subscription related services. An invoice module to handle invoice related events.
8. Since we use factory and separate service classes, it would be easier to extend the app to process new events required at a later stage. All we would need to do is, add the event in constants file, add case in factory with the corresponding Service class name, add a service class in services folder. This ensures scalability.
9. Have made the app as fault tolerant as possible.
10. Have handled duplicate event processing by handling idempotency. Have logged the events that are processed using a table StripeWebhookEvents(using external_id-> idempotency_key and event_type). This might also prevent replay attacks.
11. I'm aware that CSRF protection that is protect_from_forgery needs to be excluded for this stripe webhook endpoint in the app, but for the local scope as it works as is havent included, but in production scope this can be added later.
12. For the scope of local project have not whitelisted the stripe endpoints from which these events can come. Can be whitlisted in production scope.
13. Have covered the code base with rspecs, with unit test for even edge cases for separate files and achieved good coverage for both positive and error scenarios.

### Tests using rspec
Run the test for the repo containing the app:
```sh
 cd event_processing_service
 rspec
```
