class UserSerializer
  attr_reader :user

  def initialize(user)
    @user = user
  end

  def call
    {
      user: {
        last_name: user.last_name,
        first_name: user.first_name,
        name: user.name
      }
    }
  end

  def self.call(...)
    new(...).call
  end
end
