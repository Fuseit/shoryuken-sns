RSpec.describe Shoryuken::Sns do
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
