class ItemsController < ApplicationController
  before_action :require_user_logged_in

  def new
    
    # 空の状態で表示する必要があるので、@items をカラの配列として初期化
    
    @items = []
    
    # View で text_field_tag :keyword という input が設置予定
    #new.html.erb

    @keyword = params[:keyword]
    if @keyword.present?
      results = RakutenWebService::Ichiba::Item.search({
        keyword: @keyword,
        imageFlag: 1,
        hits: 20,
      })
      #上記のresultsからitemインスタンスの作成
      results.each do |result|
        item = Item.new(read(result))
        
        #後ほど、自分のモノリストとして追加(Want, Have)されたときにだけ Item のインスタンスを保存したい
        
        #配列に追加する
        @items << item
      end
    end
  end

  private
　
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