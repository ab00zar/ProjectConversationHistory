RSpec.describe Current, type: :model do
  it 'sets and retrieves the current user' do
    user = User.new(email: 'test@test.com')
    Current.user = user
    expect(Current.user).to eq(user)
  end
end
