RSpec.describe 'app' do
  context 'when path does not exist' do
    ['get', 'post', 'patch', 'put', 'delete'].each do |method|
      context "for #{method.upcase}s" do
        before { public_send(method, '/path') }

        it('status is 404') { expect(response.status).to eq(404) }

        it('has helpful message') do
          data = JSON.parse(response.body)
          expect(data['message']).to eq('Not found')
        end
      end
    end
  end
end
