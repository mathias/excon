require 'spec_helper'

require 'excon'

describe Excon::Middleware::RedirectFollower do
  subject(:middleware) { Excon::Middleware::RedirectFollower.new [] }

  before do
    @connection_klass = class_double("Excon::Connection").as_stubbed_const()
    @responser = double("responser", {
      request: double("data", { data: nil })
    })
  end

  describe '#response_call' do
    describe 'when Authorization header is present' do
      let(:datum) do
        {
          headers: {
            'Authorization' => 'ASDF',
            'If-None-Match' => "686897696a7c876b7e"
          },
          response: {
            status: 301,
            headers: { 'Location' => 'http://localhost:9292/new' }
          }
        }
      end

      let(:expected_params) do
        {
          headers: { 'If-None-Match' => "686897696a7c876b7e" },
          method: :get,
          scheme: "http",
          host: "localhost",
          port: 9292,
          path: "/new",
          query: nil
        }
      end

      it 'does not set user and password keys on connection params or set an Authorization header' do
        expect(@connection_klass).to receive(:new).with(expected_params).and_return(@responser)

        middleware.response_call(datum)
      end
    end
  end
end

