class UsersController < ApplicationController
  before_action :logged_in_user, only: [:index, :edit, :update, :destroy
                                        ]
  #before_action :logged_in_user, only: [:index, :edit, :update, :destroy]
  before_action :correct_user,   only: [:edit, :update]
  before_action :admin_user,     only: :destroy

  def index
    # @users = User.where(activated: FILL_IN).paginate(page: params[:page])
     @users = User.paginate(page: params[:page]).all
  end

  def show
    @user = User.find_by id: params[:id]
    @entries = @user.entries.paginate(page: params[:page])
    unless @user
      flash[:danger] = t("flash.danger.invalid_user")
      redirect_to root_url
    end
  end

  def new
    @user = User.new
  end

  def create
    #@user.activate
    @user = User.new user_params
    @user.activate
    if @user.save
      flash[:info] = "WellCome ! Please singup to login"
      #flash[:info] = "Please check your email to activate your account."
      redirect_to login_url
      #log_in @user
    else
      render :new
    end
  end

  def edit
    @user = User.find(params[:id])

  end

  def update
    @user = User.find(params[:id])

    if @user.update_attributes(user_params)
      # Handle a successful update.
      flash[:success] = "Profile updated"
      redirect_to @user
    else
      render 'edit'
    end
  end

   # Confirms a logged-in user.
  def logged_in_user
    unless logged_in?
        store_location
        flash[:danger] = "Please log in."
        redirect_to login_url
    end
  end

  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "User deleted"
    redirect_to users_url
  end

  # # Confirms an admin user.
  # def admin_user
  #     redirect_to(root_url) unless current_user.admin?
  # end
  # Follows a user.
  def follow(other_user)
    active_relationships.create(followed_id: other_user.id)
  end

  # Unfollows a user.
  def unfollow(other_user)
    active_relationships.find_by(followed_id: other_user.id).destroy
  end

  def following?(other_user)
    following.include?(other_user)
  end

  def following
   @title = "Following"
   @user  = User.find(params[:id])
   @users = @user.following.paginate(page: params[:page])
   render 'show_follow'
 end

 def followers
   @title = "Followers"
   @user  = User.find(params[:id])
   @users = @user.followers.paginate(page: params[:page])
   render 'show_follow'
 end


  private

    def user_params
      params.require(:user).permit(:name, :email, :password,
        :password_confirmation, :activated)
    end

    # Confirms the correct user.
    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_url) unless current_user?(@user)
    end

    # Confirms an admin user.
    def admin_user
      redirect_to(root_url) unless current_user.admin?
    end


end
