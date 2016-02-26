describe Coloredcoins::Connection do
  let!(:base_url) { 'http://example.com/api/v1' }
  let!(:path)     { '/some/path' }
  let!(:payload)  { { a: 'payload' } }
  let!(:resp)     { { a: 'response' } }
  let!(:params) do
    {
      method: nil,
      url: "#{base_url}#{path}",
      payload: payload,
      ssl_version: 'SSLv23'
    }
  end

  subject { Coloredcoins::Connection.new(base_url) }

  before do
    allow(RestClient::Request).to receive(:execute).and_return(resp.to_json)
  end

  describe 'get' do
    it 'should execute the call' do
      subject.get(path, payload)
      get_params = params.merge(method: :get)
      expect(RestClient::Request).to have_received(:execute).with(get_params)
    end
  end

  describe 'post' do
    it 'should execute the call' do
      subject.post(path, payload)
      post_params = params.merge(method: :post)
      expect(RestClient::Request).to have_received(:execute).with(post_params)
    end
  end

  describe 'query' do
  end
end
