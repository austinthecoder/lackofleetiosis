RSpec.describe 'app' do
  context 'root path' do
    it 'says hello' do
      data = get '/'
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
            before { @data = public_send(method, '/path') }

            it('status is 404') { expect(response.status).to eq(404) }

            it('has helpful message') do
              expect(@data['error']).to eq('Not found')
            end
          end
        end
      end
    end
  end
end
