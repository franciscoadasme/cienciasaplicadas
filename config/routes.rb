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
        get :localized
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

    resources :moments, except: [ :show ]
    resources :events do
      member do
        get :attendees
        get :download_abstracts
        get :posts
        patch 'attendes/:attendee_id/accept', action: :accept_attendee, as: :accept_attendee
        patch 'attendes/:attendee_id/reject', action: :reject_attendee, as: :reject_attendee
        delete 'attendes/:attendee_id', action: :destroy_attendee, as: :attendee
      end
      resources :speakers, except: [:show]
    end

    # Development only
    get 'mailer(/:action(/:id(.:format)))', to: 'mailer#:action', as: nil
  end
  get 'admin', to: 'admin#index'

  scope 'miembros/:user_id' do
    get 'proyectos(/:year)', to: 'projects#index', as: :user_projects, constraints: { year: /\d{4}/ }
    get 'proyectos/:id', to: 'projects#show', as: :user_project
    get 'publicaciones', to: 'users#publications_index', as: :user_publications
    get 'productividad', to: 'users#stats', as: :user_stats
    get ':id', to: 'pages#show', as: :user_page
    root to: 'users#show', as: :user
  end
  get 'miembros', to: 'users#members', as: :members

  get 'eventos/proximos', to: 'events#upcoming', as: :upcoming_events
  get 'eventos/este-mes', to: 'events#current_month', as: :current_month_events

  # TODO: remove this hack!
  t = 'second-international-conference-in-bioinformatics-simulations-and-modeling-icbsm-2017'
  get "eventos/#{t}/:name", to: redirect(path: 'eventos/icbsm2017/%{name}')
  get "eventos/#{t}", to: redirect(path: 'eventos/icbsm2017')

  constraints(year: /\d{4}/, month: /([1-9]|1[012])/) do
    get 'noticias(/:year(/:month))', to: 'posts#index', as: :posts
    get 'noticias/:year/:month/:day/:id', to: 'posts#show', as: :post

    get 'eventos(/:year(/:month))', to: 'events#index', as: :events
    get 'eventos/:id', to: 'events#show', as: :event
    match 'eventos/:id/registro', to: 'events#registration', via: [:get, :post], as: :registration_event
    get 'eventos/:id/noticias', to: 'events#posts', as: 'posts_event'
    get 'eventos/:id/invitados', to: 'events#speakers', as: 'speakers_event'

    get 'momentos(/:year(/:month))', to: 'moments#index', as: :moments
    get 'momentos/:year/:month/:day/:id', to: 'moments#show', as: :moment
  end

  # event's abstracts
  get 'eventos/:id/resumenes', to: 'events#abstracts', as: 'event_abstracts'
  get 'eventos/:event_id/resumenes/plantilla',
      to: 'abstracts#download_template',
      as: 'download_template_event_abstract'
  get 'eventos/:event_id/resumenes/envio',
      to: 'abstracts#edit',
      as: 'edit_event_abstract',
      constraints: ->(request) { request.params.key?(:token) }
  match 'eventos/:event_id/resumenes/envio',
        via: %w(patch put),
        to: 'abstracts#update',
        as: 'event_abstract',
        constraints: ->(request) { request.params.key?(:token) }
  get 'eventos/:event_id/resumenes/envio',
      to: 'abstracts#request_token',
      as: 'request_token_event_abstract'
  post 'eventos/:event_id/resumenes/envio', to: 'abstracts#send_token'

  resources :theses, only: [:index, :show], path: 'tesis'

  get 'publicaciones', to: 'publications#index', as: :publications
  get 'investigacion', to: 'pages#research', as: :research

  get :contacto, to: 'contact#new', as: :new_contact
  post :contacto, to: 'contact#create', as: :contact

  get ':id', to: 'pages#show', as: :page

  root to: 'site#index'
end
