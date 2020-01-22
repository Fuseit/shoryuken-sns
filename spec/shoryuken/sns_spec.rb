RSpec.describe Shoryuken::Sns do

  before do
    ENV['AWS_REGION'] = 'eu-west-1'
  end
  it "has a version number" do
    expect(Shoryuken::Sns::VERSION).not_to be nil
  end

  it 'Shoryuken implements delegation method sns_client' do
    Shoryuken.sns_client
  end

  it 'Shoryuken still implements old delegation methods' do
    expect(Shoryuken.groups).to eq({})
  end
end
