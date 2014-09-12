
## Yapılacaklar

Sırasıyla,

```bash
$ bundle install
$ rake db:migrate
$ rails s -p 3002
```

## Nasıl Yapıldı?

Sırasıyla,

```ruby
$ rails new CasinoClient
$ vim Gemfile
  gem 'rack-cas'
$ bundle install
$ rails g cas_session_store_migration
$ rake db:migrate

$ rails g controller Home show

$ vim config/routes.rb
  get 'home/show'
  root to: "home#show"

$ vim config/application.rb
  require 'rack-cas/session_store/active_record'
  config.rack_cas.session_store = RackCAS::ActiveRecordStore
  config.rack_cas.server_url = 'http://localhost:3000/'

$ vim config/initializers/session_store.rb
  require 'rack-cas/session_store/rails/active_record'
  CasinoClient::Application.config.session_store :rack_cas_active_record_store

$ vim app/controllers/application_controller.rb
  before_filter :fix_cas_session
  before_filter :ensure_loggedin

  def fix_cas_session
    if session[:cas].respond_to?(:with_indifferent_access)
      session[:cas] = session[:cas].with_indifferent_access
    end
  end

  def ensure_loggedin
    if session[:cas].nil? || session[:cas][:user].nil?
      render status: 401, text: "Redirecting to SSO..."
    end
  end

$ vim app/controllers/home_controller.rb
  def show
    @user = session[:cas]
  end

$ vim app/views/home/show.html.erb
  <%= debug @user %>
  <a href="/logout">Logout</a>
```
