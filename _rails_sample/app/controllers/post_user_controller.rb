class PostUserController < ApplicationController
  serializer UserSerializer

  execute do
    User.new(user_params)
  end

  private

  def user_params
    params.require(:user).permit(:first_name, :last_name)
  end
end
