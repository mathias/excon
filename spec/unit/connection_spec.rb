require 'spec_helper'

require 'excon'
require 'excon/middlewares/base'
require 'excon/middlewares/redirect_follower'

describe Excon::Connection do
  subject(:connection) { Excon::Connection.new params }

  before do
    @socket = instance_double(Excon::Socket)
    allow(@socket).to receive(:readline)

    klass_double = class_double(Excon::Socket).as_stubbed_const
    allow(klass_double).to receive(:new).and_return(@socket)
  end

  describe '.new' do
    describe 'basic auth' do
      context 'when user and password are present but nil' do
        let(:params) do
          {
            headers: {},
            method: :get,
            scheme: "http",
            host: "localhost",
            port: 9292,
            path: "/new",
            query: nil,
            user: nil,
            password: nil
          }
        end

        it 'does not set Basic Auth on the request' do
          expect(@socket).to receive(:data=).
            with(hash_including(headers: {}))

          connection.request
        end
      end
    end
  end
end

