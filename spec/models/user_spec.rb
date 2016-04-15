describe User do
  subject(:user) { described_class.new }

  it { is_expected.to have_many :reviewed_restaurants }

  it { is_expected.to respond_to(:has_reviewed?).with(1).argument }

end
