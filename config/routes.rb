Rails.application.routes.draw do
	get 'welcome/index'

	get 'signup' => 'users#new'

	post 'signup' => 'users#create'

	get 'profile' => 'users#profile'

	get 'profile/settings' => 'users#edit'

	patch 'profile' => 'users#update'

	get 'signup' => 'users#new'

	get 'login' => 'sessions#new'

	get 'workouts' => 'workouts#home'

	get 'workouts-all' => 'workouts#index'

	post 'login' => 'sessions#create'

	delete 'logout' => 'sessions#destroy'

	get 'workouts/new' => 'workouts#new'
	
	post 'workouts' => 'workouts#create'

	get 'current/:workout_length' => 'workouts#current'

	post 'current/:workout_length' => 'results#create'

	get 'workouts/:id' => 'workouts#show'

	post 'posts' => 'posts#create'

	get 'workouts/error' => 'workouts#error'

	root 'welcome#index'

	get 'results' => 'results#index'

	get 'results/all' => 'results#all'

	get 'results/current/:user_id' => 'results#current'

	get 'results/post/:post_id/user/:user_id' => 'results#show'

	get 'results/post/:post_id/user/:user_id/edit' => 'posts#edit'

	patch 'results/post/:post_id/user/:user_id' => 'posts#update'

	delete 'results/post/:post_id/user/:user_id' => 'posts#destroy'

	get 'leaderboards' => 'leaderboards#all'
	
	get 'contests/new' => 'contests#new'

	get 'contests/:id' => 'contests#show'

	post 'contests' => 'contests#create'

	get 'contests' => 'contests#index'

     get 'contests/:id/settings' => 'contests#edit'

	patch 'contests/:id/edit' => 'contests#update'

	patch 'notifications/:id' => 'notifications#read'

	post 'contests/:id/contestants' => 'contestants#create'

	delete 'contests/:id' => 'contests#destroy'

	delete 'contestants/:id' => 'contestants#destroy'

	patch 'contests/:id' => 'contestants#update'

	post 'contests/:id/comments' => 'contest_comments#create'

	delete 'contests/:id/comments/:comment_id' => 'contest_comments#destroy'
	
	get '/friends' => 'friends#index'
	
	post '/friends/:friend_id' => 'friends#create'
	
	patch '/friends/accept/:id' => 'friends#accept'
	
	patch '/friends/decline/:id' => 'friends#decline'
	
	delete '/friends/:id' => 'friends#destroy'
	
	post '/friend-invitations' => 'friend_invitations#create'
	
	get '/articles/contests' => 'articles#contests'
	
	post '/favorites/:post_id' => 'favorites#create'
	
	delete '/favorites/:id' => 'favorites#destroy'
	
	get '/messages' => 'messages#index'
	
	get '/messages/:user_id' => 'messages#new'
	
	post '/messages' => 'messages#create'
	
	delete '/messages/:id' => 'messages#destroy'
	
	resources :workouts do
	    resources :exercises
	end
	
end
