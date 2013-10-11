Dummy::Application.routes.draw do
  post 'failing' => 'failing#index'
  post 'happy' => 'happy#index'
end
