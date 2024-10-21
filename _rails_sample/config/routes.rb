Rails.application.routes.draw do
  get "/current_time", to: GetCurrentTimeController
  post "/user", to: PostUserController
end
