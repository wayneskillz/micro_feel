class UsersController < ApplicationController
  before_action :signed_in_user, only: [:index, :edit, :update, :delete]
  before_action :correct_user, only: [:edit, :update]
  before_action :admin_user,  only: :destroy

  def index
    @users = User.paginate(page: params[:page])

  end

  def show
		@user  = User.find(params[:id])
	end
  def new
  	@user = User.new
  end

  def edit
  	#@user varaiable already specified in the :correct_user before_action filter
    #@user = User.find(params[:id])
  end

  def update
   ##@user varaiable already specified in the :correct_user before_action filter
   # @user = User.find(params[:id])

    if @user.update_attributes(user_params)
      #Handle a successful update
      flash[:success] = "Profile Updated"
      redirect_to @user
    else
      render 'edit'
    end
  end

  def create
  	@user = User.new(user_params)
  	if @user.save
  		#handle a successful save
  		sign_in @user
  		flash[:success] = "Welcome to Micro Feel!"
  		redirect_to @user
  	else
  		render 'new'
  	end
  end

  def destroy 
    User.find(params[:id]).destroy
    flash[:success] = "User destroyed."
    redirect_to users_url

  end

  private
  	def user_params
  		params.require(:user).permit(:name, :email, :password, :password_confirmation)
  	end

    #Before filters/actions

    def signed_in_user
     unless signed_in?
        store_location
        redirect_to signin_url, notice: "Please sign in."
      end
    end

    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_url) unless current_user?(@user)
    end

    def admin_user

      redirect_to(root_url) unless current_user.admin?
    end
end
