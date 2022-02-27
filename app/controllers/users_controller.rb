class UsersController < ApplicationController
  def index
    @users = User.all.order({ :username => :asc })

    render({ :template => "users/index.html" })
  end

  def show
    the_username = params.fetch("the_username")
    @user = User.where({ :username => the_username }).at(0)

    render({ :template => "users/show.html.erb" })
  end

  def create
    user = User.new

    user.username = params.fetch("input_username")
    user.password = params.fetch("input_password")
    user.password_confirmation = params.fetch("input_password_confirmation")

    save_status = user.save

    if save_status == true
      session.store(:user_id, user.id) #to put the cockies when they sign up
      redirect_to("/users/#{user.username}",{ :notice => "Welcome," + user.username + "!" })
    else
      redirect_to("/user_sign_up", { :alert => user.errors.full_messages.to_sentence })
    end
  end

  def update
    the_id = params.fetch("the_user_id")
    user = User.where({ :id => the_id }).at(0)


    user.username = params.fetch("input_username")

    user.save
    
    redirect_to("/users/#{user.username}")
  end

  def destroy
    username = params.fetch("the_username")
    user = User.where({ :username => username }).at(0)

    user.destroy

    redirect_to("/users")
  end

  def new_registration_form
    render({:template=>"users/signup_form_html.erb"})
  end

  def toast_cookies
    reset_session

    redirect_to("/",{ :notice => "see ya later!"})
  end

  def new_session_form
    render({:template=>"users/signin_form_html.erb"})
  end

  def authenticate
    # get the username from params
    un = params.fetch("input_username")
    
    # get te password from params
    pw = params.fetch("input_password")

    # look up the record from the db matching username
    user = User.where({:username => un}).at(0)

    # if there is no record, redirect back to sign in form
    if user == nil
      redirect_to("/user_sign_in",{:alert => "No one by that name"})
    elsif user.authenticate(pw)
      # if there is a record, check to see if password matches
      # if password matchies, set the cookie
      # redirect to homepage
      session.store(:user_id, user.id)
      redirect_to("/", {:notice => "welcome back,"+ user.username + "!"})
    else
      # if not, redirect to the sign in form
      redirect_to("/user_sign_in",{:alert => "Nice try, sucker!"})
    end

    



  end

end
