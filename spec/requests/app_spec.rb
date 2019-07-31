RSpec.describe 'app', :type => :request do
  context 'root path' do
    it 'says hello' do
      get '/'
      data = JSON.parse(response.body)
      expect(data['message']).to eq('Hello, friends')
    end
  end

  context 'when path does not exist' do
    [
      ['get', ['/path']],
      ['post', ['/', '/path']],
      ['patch', ['/', '/path']],
      ['put', ['/', '/path']],
      ['delete', ['/', '/path']],
    ].each do |method, paths|
      context "for #{method.upcase}s" do
        paths.each do |path|
          context "example: #{path}" do
            before { public_send(method, '/path') }

            it('status is 404') { expect(response.status).to eq(404) }

            it('has helpful message') do
              data = JSON.parse(response.body)
              expect(data['error']).to eq('Not found')
            end
          end
        end
      end
    end
  end
end
