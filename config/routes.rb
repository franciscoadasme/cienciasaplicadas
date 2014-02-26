CbsmWebsite::Application.routes.draw do
  devise_for :users, path: 'auth', controllers: { sessions: 'auth/sessions', omniauth_callbacks: 'auth/omniauth_callbacks', passwords: 'auth/passwords' }, skip: [ :invitation ]
  as :user do
    scope 'admin/users/invitation' do
      get :resend, to: 'admin/users/invitations#resend_invitation', as: :resend_user_invitation
      post '/', to: 'admin/users/invitations#create', as: :user_invitation
      get :new, to: 'admin/users/invitations#new', as: :new_user_invitation
      patch '/', to: 'admin/users/invitations#update'
      put '/', to: 'admin/users/invitations#update'
    end
    get 'invitation/accept', to: 'admin/users/invitations#edit', as: :accept_user_invitation
  end

  namespace :admin do
    resources :pages, only: [ :edit, :update, :destroy ] do
      member do
        patch :publish
        patch :trash
        patch :restore
      end
      collection { post :sort  }
    end

    resources :posts, except: [ :show ] do
      member do
        patch :publish
        patch :withhold
      end
    end

    resource :account, only: [ :update ], controller: :account do
      resources :pages, only: [ :index, :new, :create ]
      get :profile, to: 'account#edit'
      get :settings, to: 'settings#edit'
      patch :settings, to: 'settings#update'
      put :settings, to: 'settings#update'
    end

    resource :group, only: [ :update ], controller: :group do
      resources :pages, only: [ :index, :new, :create ]
      get :customize, to: 'group#edit'
    end

    resources :users, only: [ :index, :destroy ] do
      member do
        patch :promote
        patch :demote
        patch :change_position
      end
    end
    resources :positions, except: [ :show ] do
      collection { post :sort  }
    end

    resources :publications, only: [ :index, :edit, :update ] do
      member do
        patch :link
        delete :unlink
        patch :toggle_flag
        get :author_list
      end

      collection do
        post :import
      end
    end
    resources :journals, only: [ :index, :edit, :update ] do
      collection { post :merge }
    end

    resources :projects, except: [ :show ]

    resources :theses

    resources :announcements, only: [ :new, :create ]
    resources :mailing_lists do
      member do
        get :add_member
        post :add_member
        delete :remove_member

        get :new_message
        post :send_message
      end
    end
    resources :contacts

    resources :moments, except: [ :show ]
    resources :events

    # Development only
    get 'mailer(/:action(/:id(.:format)))', to: 'mailer#:action', as: nil
  end
  get 'admin', to: 'admin#dashboard'

  scope 'miembros/:user_id' do
    get 'proyectos', to: 'projects#index', as: :projects_user
    get 'proyectos/:id', to: 'projects#show', as: :project_user
    get 'publicaciones', to: 'publications#index', as: :publications_user
    get ':id', to: 'pages#show', as: :page_user
    root to: 'users#show', as: :user
  end

  constraints(year: /\d{4}/, month: /([1-9]|1[012])/) do
    get 'noticias(/:year(/:month))', to: 'posts#index', as: :posts
    get 'noticias/:year/:month/:day/:id', to: 'posts#show', as: :post

    get 'eventos(/:year(/:month))', to: 'events#index', as: :events
    get 'eventos/:id', to: 'events#show', as: :event

    get 'momentos(/:year(/:month))', to: 'moments#index', as: :moments
    get 'momentos/:year/:month/:day/:id', to: 'moments#show', as: :moment
  end

  get :contact, to: 'site#contact'
  get ':id', to: 'pages#show', as: :page

  root to: 'site#index'
end