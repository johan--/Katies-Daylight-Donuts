class UserObserver < ActiveRecord::Observer
  def before_update(user)
    if user.crypted_password_changed?
      UserNotifier.deliver_password(user, user.password)
    end
  end
end
