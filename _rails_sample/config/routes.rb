Rails.application.routes.draw do
  get "/users/:id", to: GetUserController
  post "/users", to: PostUserController
end
