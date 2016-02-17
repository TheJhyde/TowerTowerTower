class UserMailer < ApplicationMailer

  def account_activation(user)
    @user = user
    mail to: user.email, subject: "Activate Your Account"
  end
  
  def password_reset(user)
    @user = user
    mail to: user.email, subject: "Password Reset"
  end
end
