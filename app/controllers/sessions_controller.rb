class SessionsController < ApplicationController
  
  def new
  
    @title = "Sign in"
  end

  def create
    user = User.authenticate(params[:session][:email], params[:session][:passowrd])
    if user.nil?
      flash.now[:error] = "Invalid email or password"
      @title = "Sign in"
      render 'new'
    else
    
    end
  end
  def destroy
    sign_out
    redirect_to roo_path
  end



end
