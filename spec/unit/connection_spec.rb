require 'spec_helper'

require 'excon'

describe Excon::Connection do
  subject(:connection) { Excon::Connection.new params }

  before do
    @socket = instance_double(Excon::Socket)
    allow(@socket).to receive(:write)
    allow(@socket).to receive(:readline)
    allow(@socket).to receive(:close)

    klass_double = class_double(Excon::Socket).as_stubbed_const
    allow(klass_double).to receive(:new).and_return(@socket)

    response_klass_double = class_double(Excon::Response).as_stubbed_const
    allow(response_klass_double).to receive(:new)
    allow(response_klass_double).to receive(:parse).and_return({})
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
            with(hash_including(headers: {
            "Host"=>"localhost:9292"
          }))

          connection.request
        end
      end
    end
  end
end

