class User < ApplicationRecord
  before_save { self.email.downcase! }
  validates :name, presence: true, length: { maximum: 50 }
  validates :email, presence: true, length: { maximum: 255 },
                    format: { with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i },
                    uniqueness: { case_sensitive: false }
  has_secure_password
  
  #user.ownerships で中間テーブルのインスタンス群
  #user.items で user が want/have している items を取得するが、
  #typeカラムがあるため、Want した Item だけでなく、そのままではHave した Item も全て取得してしまう
  #よって、モデルWantを作成[rails g model Want --parent=Ownership]
  #Want は type カラムが 'Want' と固定されるだけで、レコードの保存は ownerships テーブル
  has_many :ownerships
  has_many :items, through: :ownerships
  
  #よって、モデルWantを作成[rails g model Want --parent=Ownership]
  #Want は type カラムが 'Want' と固定されるだけで、レコードの保存は ownerships テーブル
  #user.wants を実行すると type='Want' な Ownerships を取得
  #user.want_items で「Want した Item だけ」を取得
  #詳細はwant.rbを参照
  
  has_many :wants
  has_many :want_items, through: :wants, source: :item
  
  #user.want(item) で Want できるように！
  
  def want(item)
    self.wants.find_or_create_by(item_id: item.id)
  end

  def unwant(item)
    want = self.wants.find_by(item_id: item.id)
    want.destroy if want
  end

  def want?(item)
    self.want_items.include?(item)
  end
  
  #Item Model に has_many :wants と書くと、自動的に Want クラスだと判断されるが、 
  #has_many :haves と書くと Hafe クラスと判断されてしまうので、class_name: 'Have'と明示する
  has_many :haves, class_name: 'Have'
  has_many :have_items, through: :haves, source: :item
  
  def have(item)
    self.haves.find_or_create_by(item_id: item.id)
  end

  def nothave(item)
    have = self.haves.find_by(item_id: item.id)
    have.destroy if have
  end

  def have?(item)
    self.have_items.include?(item)
  end
  
  
end
