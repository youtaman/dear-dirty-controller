class PostUserController < ApplicationController
  def execute
    create_user
  end

  private

  def create_user
    # User.create!(user_params)
    user_params
  end

  def user_params
    params.require(:user).permit(:first_name, :last_name)
  end
end
