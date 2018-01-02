class UsersController < ApplicationController
  skip_before_action :authorize_request, only: :create

  def index
    @users = User.all
    json_response(@users)
  end

  # POST /signup
  # return authenticated token upon signup
  def create
    user = User.create!(user_params)
    auth_token = AuthenticateUser.new(user.email, user.password).call
    response = { message: Message.account_created, auth_token: auth_token }
    json_response(response, :created)
  end

  private

  def user_params
    params.permit(
        :name,
        :email,
        :password,
        :password_confirmation
    )
  end

  resource_description do
    short 'Site members'
    formats ['json']
    param :id, Fixnum, :desc => "User ID", :required => false
    param :resource_param, Hash, :desc => 'Param description for all methods' do
      param :ausername, String, :desc => "Username for login", :required => true
      param :apassword, String, :desc => "Password for login", :required => true
    end
    api_version "development"
    error 404, "Missing"
    error 500, "Server crashed for some <%= reason %>", :meta => {:anything => "you can think of"}
    error :unprocessable_entity, "Could not save the entity."
    meta :author => {:name => 'John', :surname => 'Doe'}
    deprecated false
    description <<-EOS
    == Long description
     Example resource for rest api documentation
     These can now be accessed in <tt>shared/header</tt> with:
       Headline: <%= headline %>
       First name: <%= person.first_name %>

     If you need to find out whether a certain local variable has been
     assigned a value in a particular render call, you need to use the
     following pattern:

     <% if local_assigns.has_key? :headline %>
        Headline: <%= headline %>
     <% end %>

    Testing using <tt>defined? headline</tt> will not work. This is an
    implementation restriction.

    === Template caching

    By default, Rails will compile each template to a method in order
    to render it. When you alter a template, Rails will check the
    file's modification time and recompile it in development mode.
    EOS
  end
end
