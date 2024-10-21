class GetUserController < ApplicationController
  execute do
    User.find(params[:id])
  end

  # Behaves the same as `serialize UserSerializer`
  serialize do
    {
      user: {
        last_name: user.last_name,
        first_name: user.first_name,
        name: user.name
      }
    }
  end
end
