require 'pry'
class TweetsController < ApplicationController

    get '/tweets' do
        @tweets = Tweet.all 
        if !logged_in?
            redirect '/login'
        else 
            erb :'tweets/tweets'
        end
    end

    get '/tweets/new' do
        if !logged_in?
            redirect '/login'
        else   
        erb :'/tweets/new'
        end 
    end

    post '/tweets' do 
      if params[:content] == ''
        redirect '/tweets/new'
      else
       @tweet = Tweet.create(:content => params[:content])
       @tweet.user_id = current_user.id
       @tweet.save
       redirect "/tweets/#{@tweet.id}" 
      end  
    end

    get '/tweets/:id/edit' do
        if !logged_in?
          redirect '/login'
        end
        @tweet = Tweet.find(params[:id])
        if @tweet.user_id != current_user.id
            flash[:message] = "Sorry, you cannot edit tweets that are not yours!"
            redirect '/tweets'
        else
          erb :'/tweets/edit_tweet'
       end 
    end

    get '/tweets/:id' do
      if !logged_in?
        redirect '/login'
      else
        @tweet = Tweet.find(params[:id])
        @user = current_user
        erb :'/tweets/show_tweet'
     end 
    end

    patch '/tweets/:id' do 
      @tweet = Tweet.find(params[:id])
        if params[:tweet][:content] == ''
            redirect "/tweets/#{@tweet.id}/edit"
        else 
            @tweet.update(params[:tweet]) 
            @tweet.user_id = current_user.id
            @tweet.save 
            redirect "/tweets/#{@tweet.id}"
        end
    end

    delete '/tweets/:id/delete' do
        if !logged_in? 
            redirect '/login'
        end 
        @tweet = Tweet.find(params[:id])
        if @tweet.id == current_user.id
            @tweet.destroy
            redirect '/tweets'
        else
            flash[:message] = "Sorry, you can't delete tweets that aren't yours!"
            redirect '/tweets'
        end
        binding.pry 
    end


end
