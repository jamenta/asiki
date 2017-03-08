module UserHelper
  def user_image_by_id(user_id, size)
    @image_user = User.find(user_id.to_i)
    if @image_user.gravatar_bool
	  gravatar_id = Digest::MD5.hexdigest(@image_user.gravatar.downcase)
	  image_tag("http://gravatar.com/avatar/#{gravatar_id}.png?s=#{size}", class: "gravatar-image")
    else
	  emojify @image_user.emoji_title, img_attrs: { title: nil, style: "height:#{size}px; width:#{size}px;" }
    end
  end

end

