class Want < Ownership
  
  #STI
  #モデルの継承関係で表現されるものに関して、Rails は標準機能を提供しています。
  #それは、Want というクラス名であるが wants テーブルを探さず、
  #継承元 (Ownership) の保存先テーブル (ownerships) を自分のテーブルとして認識し、
  #そのテーブルの type カラムがクラス名と同一 (‘Want’) であるレコードだけを Want クラスのインスタンスとして扱うという取り決めです。
  #具体的には、Want.all を実行すると、 SELECT ownerships.* FROM ownerships WHERE ownerships.type IN ('Want') という SQL が実行され、
  #ownerships のテーブルの type IN ('Want') (type = 'Want' と同じ) なレコードのみを取得

end
