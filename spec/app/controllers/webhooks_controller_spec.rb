require 'rails_helper'

RSpec.describe WebhooksController, type: :controller do
  describe 'POST #stripe' do
    let(:payload) { 'payload_data' }
    let(:sig_header) { 'signature_header' }
    let(:event_type) { 'customer.subscription.created' }
    let(:event_data) { double('EventData') }
    let(:event) { double('Event', type: event_type, data: double('Data', object: event_data)) }
    let(:service) { instance_double(ServiceBase, call: nil) }

    before do
      allow(request).to receive(:body).and_return(double('Body', read: payload))
      allow(request.env).to receive(:[]).with('HTTP_STRIPE_SIGNATURE').and_return(sig_header)
    end

    context 'when event is successfully parsed' do
      before do
        allow(StripeEventVerifier).to receive(:new).with(payload, sig_header).and_return(double('StripeEventVerifier', verify_and_parse_event: event))
      end

      it 'handles the event with the appropriate service' do
        expect(ServiceFactory).to receive(:new).with(event_type).and_return(double('ServiceFactory', create_service: service))
        expect(service).to receive(:call).with(event_data)

        post :stripe

        expect(response).to have_http_status(:ok)
      end
    end

    context 'when an error occurs during parsing' do
      before do
        allow(StripeEventVerifier).to receive(:new).with(payload, sig_header).and_raise(JSON::ParserError, 'JSON parsing error')
      end

      it 'returns a bad request response' do
        post :stripe

        expect(response).to have_http_status(:bad_request)
        expect(response.body).to eq({ error: 'JSON parsing error' }.to_json)
      end
    end
  end
end
