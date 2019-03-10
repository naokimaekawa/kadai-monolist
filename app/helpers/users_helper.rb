module UsersHelper
  def gravatar_url(user, options = { size: 80 })
    gravatar_id = Digest::MD5::hexdigest(user.email.downcase)
    size = options[:size]
    <%# Gravatar で自分のメールアドレスに対応する画像が登録されていない場合に使用されるデフォルトイメージを変更%>
    <%# mp=(mystery-person) a simple, cartoon-style silhouetted outline of a person (does not vary by email hash)%>
    "https://secure.gravatar.com/avatar/#{gravatar_id}?s=#{size}&d=mp"
  end
end