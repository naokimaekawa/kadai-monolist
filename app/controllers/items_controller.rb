class ItemsController < ApplicationController
  before_action :require_user_logged_in
  
  #item配下でWantしたユーザーを表示するため
  def show
    @item = Item.find(params[:id])
    
    #それぞれitem.rbで定義したwant_usersとhave_usersを利用
    @want_users = @item.want_users
    @have_users = @item.have_users
    
  end
  
  
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
        
        #item = Item.new(read(result))から変更、ownerships_controllerでも同じメソッドを使用している
        #既に保存されている Item に関しては、 item.id の値も含めたく、この item.id はフォームから Unwant するときに使用するため。
        #newで全てを保存していないインスタンスにすると困る
        item = Item.find_or_initialize_by(read(result))
        
        #後ほど、自分のモノリストとして追加(Want, Have)されたときにだけ Item のインスタンスを保存したい
        
        #配列に追加する
        @items << item
      end
    end
  end
  
  #privateのdef readをapplication_controllerに移動
  #ownerships_controllerで使用するため
  
end