require './config/environment'
require 'rack-flash'
require 'pry'

class ApplicationController < Sinatra::Base

  configure do
    set :public_folder, 'public'
    set :views, 'app/views'
    enable :sessions 
    set :session_secret, "1cc568437824f34abff9dfdc958a11065626c4f5b59dfd1bfac320422afd24385705943e2e72b649a405501b680a96720133bbb9ba263140190b58c8c555164a"
    use Rack::Flash
  end

  get '/' do 
    erb :index
  end
  
  get '/signup' do
    if logged_in?
      redirect '/tweets'
    else
      erb :'/create_user'
    end
  end

  post '/signup' do 
    if params[:username] == '' || params[:email] == '' || params[:password] == ''
      flash[:message] = "Error - Please Try Again!"
      redirect '/users/signup'
    else
      @user = User.create(:username => params["username"], :email => params["email"], :password => params["password"])
      session[:user_id] = @user.id
      flash[:message] = 'Success! User Created.'
      redirect "/tweets"
    end  
  end

  get '/login' do
    if logged_in?
      redirect '/tweets'
    else 
    erb :'/login'
    end
  end

  post '/login' do 
    @user = User.find_by(:username => params[:username])
    if @user && @user.authenticate(params[:password])
      session[:user_id] = @user.id 
      redirect '/tweets'
    else
      flash[:message] = 'Uhoh, login failed. Please try again!'
      redirect '/login'
    end
  end

  get '/logout' do 
    if logged_in?
      session.clear
      redirect '/login'
    else
      redirect '/'
    end 
  end

  helpers do
    def logged_in?
      !!session[:user_id]
    end

    def current_user
      User.find(session[:user_id])
    end
  end

end
