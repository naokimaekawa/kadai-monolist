class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  include SessionsHelper

  private

  def require_user_logged_in
    unless logged_in?
      redirect_to login_url
    end
  end
  
  #ownerships_controllerで使用するため。item_controllerから移動
  #もともとitems_controllerではprivateで定義していたが、外す
#resultで受け取ったもののうち、必要な値をresultで読み出し、code,name,url,image_urlにハッシュとして入れる

  def read(result)
    code = result['itemCode']
    name = result['itemName']
    url = result['itemUrl']
    #楽天APIの仕様上、サイズ指定無しの画像を取得できない
    #gsub は文字列置換用のメソッドで、第一引数を見つけ出して、第二引数に置換するメソッド。
    #今回、第ニ引数に '' とカラ文字を入れているので、見つけたら削除。
    image_url = result['mediumImageUrls'].first['imageUrl'].gsub('?_ex=128x128', '')
    

    {
      code: code,
      name: name,
      url: url,
      image_url: image_url,
    }
  end
end