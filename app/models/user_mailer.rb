class UserMailer < ActionMailer::Base
  def reset_password(user,reset_link)
    recipients  user.email
    from        "[Intranet SHP] <fer@wadomo.com>"
    subject     "[Intranet SHP] Password reset"
    body        :user => user, :reset_link => reset_link
  end
end