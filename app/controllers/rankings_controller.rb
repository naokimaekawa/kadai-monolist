class RankingsController < ApplicationController
  def want
    #ハッシュデータ
    #Want.rankingはWantクラスのクラスメソッド
    @ranking_counts = Want.ranking
    
    #@ranking_counts.keysでキー取得
    @items = Item.find(@ranking_counts.keys)
  end
end
