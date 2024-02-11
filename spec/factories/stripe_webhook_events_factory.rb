FactoryBot.define do
  factory :stripe_webhook_event do
    transient do
      subscription_id { "sub_#{SecureRandom.hex(14)}" }
      invoice_id { "in_#{SecureRandom.hex(14)}" }
    end

    external_id { SecureRandom.uuid }
    state { 0 } # Default state, you can adjust this as needed
    processing_errors { nil } # Default to nil, adjust as needed

    trait :subscription_created do
      data do
      json_data =  
      {
        "object" => {
          "id" => subscription_id,
          "object" => "subscription",
          "application" => nil,
          "application_fee_percent" => nil,
          "automatic_tax" => {
            "enabled" => false,
            "liability" => nil
          },
          "billing_cycle_anchor" => 1707577893,
          "billing_cycle_anchor_config" => nil,
          "billing_thresholds" => nil,
          "cancel_at" => nil,
          "cancel_at_period_end" => false,
          "canceled_at" => nil,
          "cancellation_details" => {
            "comment" => nil,
            "feedback" => nil,
            "reason" => nil
          },
          "collection_method" => "send_invoice",
          "created" => 1707577893,
          "currency" => "usd",
          "current_period_end" => 1710083493,
          "current_period_start" => 1707577893,
          "customer" => "cus_PWut9jJYNTYqvX",
          "days_until_due" => 0,
          "default_payment_method" => nil,
          "default_source" => nil,
          "default_tax_rates" => [],
          "description" => nil,
          "discount" => nil,
          "ended_at" => nil,
          "invoice_settings" => {
            "account_tax_ids" => nil,
            "issuer" => {
              "type" => "self"
            }
          },
          "items" => {
            "object" => "list",
            "data" => [
              {
                "id" => "si_PXMx8jZp1Ykuyq",
                "object" => "subscription_item",
                "billing_thresholds" => nil,
                "created" => 1707577894,
                "metadata" => {},
                "plan" => {
                  "id" => "price_1Ohx2mHOAqhEL3lzZ3tZOA7P",
                  "object" => "plan",
                  "active" => true,
                  "aggregate_usage" => nil,
                  "amount" => 1500,
                  "amount_decimal" => "1500",
                  "billing_scheme" => "per_unit",
                  "created" => 1707496516,
                  "currency" => "usd",
                  "interval" => "month",
                  "interval_count" => 1,
                  "livemode" => false,
                  "metadata" => {},
                  "nickname" => nil,
                  "product" => "prod_PX14cUr3cE2J9n",
                  "tiers_mode" => nil,
                  "transform_usage" => nil,
                  "trial_period_days" => nil,
                  "usage_type" => "licensed"
                },
                "price" => {
                  "id" => "price_1Ohx2mHOAqhEL3lzZ3tZOA7P",
                  "object" => "price",
                  "active" => true,
                  "billing_scheme" => "per_unit",
                  "created" => 1707496516,
                  "currency" => "usd",
                  "custom_unit_amount" => nil,
                  "livemode" => false,
                  "lookup_key" => nil,
                  "metadata" => {},
                  "nickname" => nil,
                  "product" => "prod_PX14cUr3cE2J9n",
                  "recurring" => {
                    "aggregate_usage" => nil,
                    "interval" => "month",
                    "interval_count" => 1,
                    "trial_period_days" => nil,
                    "usage_type" => "licensed"
                  },
                  "tax_behavior" => "unspecified",
                  "tiers_mode" => nil,
                  "transform_quantity" => nil,
                  "type" => "recurring",
                  "unit_amount" => 1500,
                  "unit_amount_decimal" => "1500"
                },
                "quantity" => 1,
                "subscription" => subscription_id,
                "tax_rates" => []
              }
            ],
            "has_more" => false,
            "total_count" => 1,
            "url" => "/v1/subscription_items?subscription=sub_1OiIDJHOAqhEL3lzqgycCLBD"
          },
          "latest_invoice" => "in_1OiIDJHOAqhEL3lzCOYUfRVi",
          "livemode" => false,
          "metadata" => {},
          "next_pending_invoice_item_invoice" => nil,
          "on_behalf_of" => nil,
          "pause_collection" => nil,
          "payment_settings" => {
            "payment_method_options" => nil,
            "payment_method_types" => nil,
            "save_default_payment_method" => "off"
          },
          "pending_invoice_item_interval" => nil,
          "pending_setup_intent" => nil,
          "pending_update" => nil,
          "plan" => {
            "id" => "price_1Ohx2mHOAqhEL3lzZ3tZOA7P",
            "object" => "plan",
            "active" => true,
            "aggregate_usage" => nil,
            "amount" => 1500,
            "amount_decimal" => "1500",
            "billing_scheme" => "per_unit",
            "created" => 1707496516,
            "currency" => "usd",
            "interval" => "month",
            "interval_count" => 1,
            "livemode" => false,
            "metadata" => {},
            "nickname" => nil,
            "product" => "prod_PX14cUr3cE2J9n",
            "tiers_mode" => nil,
            "transform_usage" => nil,
            "trial_period_days" => nil,
            "usage_type" => "licensed"
          },
          "quantity" => 1,
          "schedule" => nil,
          "start_date" => 1707577893,
          "status" => "active",
          "test_clock" => nil,
          "transfer_data" => nil,
          "trial_end" => nil,
          "trial_settings" => {
            "end_behavior" => {
              "missing_payment_method" => "create_invoice"
            }
          },
          "trial_start" => nil
        }
      }
      json_data.to_json
      end
    end

    trait :invoice_payment_succeeded do
      data do
      json_data = {
        "object" => {
          "id" => invoice_id,
          "object" => "invoice",
          "account_country" => "LU",
          "account_name" => "jhvghjg",
          "account_tax_ids" => nil,
          "amount_due" => 1500,
          "amount_paid" => 1500,
          "amount_remaining" => 0,
          "amount_shipping" => 0,
          "application" => nil,
          "application_fee_amount" => nil,
          "attempt_count" => 1,
          "attempted" => true,
          "auto_advance" => false,
          "automatic_tax" => {
            "enabled" => false,
            "liability" => nil,
            "status" => nil
          },
          "billing_reason" => "subscription_create",
          "charge" => "ch_3OiIDaHOAqhEL3lz0QYF3S1w",
          "collection_method" => "send_invoice",
          "created" => 1707577893,
          "currency" => "usd",
          "custom_fields" => nil,
          "customer" => "cus_PWut9jJYNTYqvX",
          "customer_address" => nil,
          "customer_email" => "priyankabs96@gmail.com",
          "customer_name" => "priyanka",
          "customer_phone" => nil,
          "customer_shipping" => nil,
          "customer_tax_exempt" => "none",
          "customer_tax_ids" => [],
          "default_payment_method" => nil,
          "default_source" => nil,
          "default_tax_rates" => [],
          "description" => nil,
          "discount" => nil,
          "discounts" => [],
          "due_date" => 1707609599,
          "effective_at" => 1707577910,
          "ending_balance" => 0,
          "footer" => nil,
          "from_invoice" => nil,
          "hosted_invoice_url" => "https://invoice.stripe.com/i/acct_1OhXHpHOAqhEL3lz/test_YWNjdF8xT2hYSHBIT0FxaEVMM2x6LF9QWE14cG1kelBzM0dhVklPNVc2WUpXT0dBYURtTkJILDk4MTE4NzEy0200P5z8ShME?s=ap",
          "invoice_pdf" => "https://pay.stripe.com/invoice/acct_1OhXHpHOAqhEL3lz/test_YWNjdF8xT2hYSHBIT0FxaEVMM2x6LF9QWE14cG1kelBzM0dhVklPNVc2WUpXT0dBYURtTkJILDk4MTE4NzEy0200P5z8ShME/pdf?s=ap",
          "issuer" => { "type" => "self" },
          "last_finalization_error" => nil,
          "latest_revision" => nil,
          "lines" => {
            "object" => "list",
            "data" => [
              {
                "id" => "il_1OiIDJHOAqhEL3lzIxlh6FaV",
                "object" => "line_item",
                "amount" => 1500,
                "amount_excluding_tax" => 1500,
                "currency" => "usd",
                "description" => "1 × myproduct (at $15.00 / month)",
                "discount_amounts" => [],
                "discountable" => true,
                "discounts" => [],
                "livemode" => false,
                "metadata" => {},
                "period" => {
                  "end" => 1710083493,
                  "start" => 1707577893
                },
                "plan" => {
                  "id" => "price_1Ohx2mHOAqhEL3lzZ3tZOA7P",
                  "object" => "plan",
                  "active" => true,
                  "aggregate_usage" => nil,
                  "amount" => 1500,
                  "amount_decimal" => "1500",
                  "billing_scheme" => "per_unit",
                  "created" => 1707496516,
                  "currency" => "usd",
                  "interval" => "month",
                  "interval_count" => 1,
                  "livemode" => false,
                  "metadata" => {},
                  "nickname" => nil,
                  "product" => "prod_PX14cUr3cE2J9n",
                  "tiers_mode" => nil,
                  "transform_usage" => nil,
                  "trial_period_days" => nil,
                  "usage_type" => "licensed"
                },
                "price" => {
                  "id" => "price_1Ohx2mHOAqhEL3lzZ3tZOA7P",
                  "object" => "price",
                  "active" => true,
                  "billing_scheme" => "per_unit",
                  "created" => 1707496516,
                  "currency" => "usd",
                  "custom_unit_amount" => nil,
                  "livemode" => false,
                  "lookup_key" => nil,
                  "metadata" => {},
                  "nickname" => nil,
                  "product" => "prod_PX14cUr3cE2J9n",
                  "recurring" => {
                    "aggregate_usage" => nil,
                    "interval" => "month",
                    "interval_count" => 1,
                    "trial_period_days" => nil,
                    "usage_type" => "licensed"
                  },
                  "tax_behavior" => "unspecified",
                  "tiers_mode" => nil,
                  "transform_quantity" => nil,
                  "type" => "recurring",
                  "unit_amount" => 1500,
                  "unit_amount_decimal" => "1500"
                },
                "proration" => false,
                "proration_details" => { "credited_items" => nil },
                "quantity" => 1,
                "subscription" => subscription_id,
                "subscription_item" => "si_PXMx8jZp1Ykuyq",
                "tax_amounts" => [],
                "tax_rates" => [],
                "type" => "subscription",
                "unit_amount_excluding_tax" => "1500"
              }
            ],
            "has_more" => false,
            "total_count" => 1,
            "url" => "/v1/invoices/in_1OiIDJHOAqhEL3lzCOYUfRVi/lines"
          },
          "livemode" => false,
          "metadata" => {},
          "next_payment_attempt" => nil,
          "number" => "5EBC22E2-0089",
          "on_behalf_of" => nil,
          "paid" => true,
          "paid_out_of_band" => false,
          "payment_intent" => "pi_3OiIDaHOAqhEL3lz0SbLJquo",
          "payment_settings" => {
            "default_mandate" => nil,
            "payment_method_options" => nil,
            "payment_method_types" => nil
          },
          "period_end" => 1707577893,
          "period_start" => 1707577893,
          "post_payment_credit_notes_amount" => 0,
          "pre_payment_credit_notes_amount" => 0,
          "quote" => nil,
          "receipt_number" => nil,
          "rendering" => nil,
          "rendering_options" => nil,
          "shipping_cost" => nil,
          "shipping_details" => nil,
          "starting_balance" => 0,
          "statement_descriptor" => nil,
          "status" => "paid",
          "status_transitions" => {
            "finalized_at" => 1707577910,
            "marked_uncollectible_at" => nil,
            "paid_at" => 1707577910,
            "voided_at" => nil
          },
          "subscription" => "sub_1OiIDJHOAqhEL3lzqgycCLBD",
          "subscription_details" => { "metadata" => {} },
          "subtotal" => 1500,
          "subtotal_excluding_tax" => 1500,
          "tax" => nil,
          "test_clock" => nil,
          "total" => 1500,
          "total_discount_amounts" => [],
          "total_excluding_tax" => 1500,
          "total_tax_amounts" => [],
          "transfer_data" => nil,
          "webhooks_delivered_at" => 1707577894
        }
      }
      json_data.to_json
    end
    end

    trait :subscription_canceled do
      data { nil }
    end
  end
end
