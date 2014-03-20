Dummy::Application.routes.draw do
  post 'failing' => 'failing#index'
  post 'failure' => 'failing#failure'

  post 'happy' => 'happy#index'
  post 'success' => 'happy#success'
end
