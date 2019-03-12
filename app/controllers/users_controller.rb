class UsersController < ApplicationController
  before_action :require_user_logged_in, only: [:show]
  
  def show
    @user = User.find(params[:id])
    
    #ユーザー詳細ページでも表示
    #Want も Have もした場合に、商品がどちらにも一つずつ（結果、重複した商品が2つ）取得するところを、
    #重複した商品は .uniq とすれば、重複を防いで取得可能
    @items = @user.items.uniq
    @count_want = @user.want_items.count
    
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
  
    if @user.save
      flash[:success] = 'ユーザを登録しました。'
      redirect_to @user
    else
      flash.now[:danger] = 'ユーザの登録に失敗しました。'
      render :new
    end
  end

  private
  
  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end
end
