class OwnershipsController < ApplicationController
  def create
    
    #Item.find_or_initialize_by は、
    #まず Item.find_by して見つかればテーブルに保存されていたインスタンスを返し、
    #見つからなければ Item.new して新規作成
    @item = Item.find_or_initialize_by(code: params[:item_code])
    
    
    #@item.persisted? は、取得したインスタンス @item が、既に保存されているかどうかを判断し、
    #保存されていれば true を返し、保存されていなければ false
    unless @item.persisted?
      
      # @item が保存されていない場合[unless]、先に @item を保存する
      results = RakutenWebService::Ichiba::Item.search(itemCode: @item.code)
      
      #@item.codeは一つだが、配列なので、firstで取得している
      #また、read は もともとitems_controller.rb に書かれていたもので、そのままだと使用できないので、
      #あとで application_controller.rb へ移動
      @item = Item.new(read(results.first))
      @item.save
    end

    # Want 関係として保存
    #_want_button.html.erbの、<%= hidden_field_tag :type, 'Want' %>からきている
    if params[:type] == 'Want'
      current_user.want(@item)
      flash[:success] = '商品を Want しました。'
    
    elsif params[:type] == 'Have'
      current_user.have(@item)
      flash[:success] = '商品を Have しました。'
    
    end

    redirect_back(fallback_location: root_path)
  end

  def destroy
    @item = Item.find(params[:item_id])

    if params[:type] == 'Want'
      current_user.unwant(@item) 
      flash[:success] = '商品の Want を解除しました。'
    
    elsif params[:type] == 'Have'
      current_user.nothave(@item) 
      flash[:success] = '商品の Have を解除しました。'
    
    end

    redirect_back(fallback_location: root_path)
  end
end