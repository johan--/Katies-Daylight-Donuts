module Admin::UsersHelper
  def api_key(user)
    if !user.new_record? && user.api_enabled?
      content_tag :p, :class => "grey-box", :id => "api_key" do
        content_tag :strong do
          "Yor Api Key: "
        end.concat(user.api_key)
      end
    end
  end
end
