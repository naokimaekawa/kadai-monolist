class ToppagesController < ApplicationController
  def index
    #toppageに表示するための@itemsを定義
    @items = Item.order('updated_at DESC')
  end
end
