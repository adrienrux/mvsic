class UserMailer < ActionMailer::Base
  default from: 'mvsicio@gmail.com'

  def schedule_email(user, schedule)
    @schedule = schedule
    @festival = schedule.festival
    @user = user
    subject = "Here's your #{schedule.festival.current_state} for #{schedule.festival.name}!"
    mail(to: @user.email, subject: subject)
  end

  def feedback_email(user_name, user_email, message)
    @user_name = user_name
    @user_email = user_email
    @message = message
    subject = "User feedback [#{user_name}: #{user_email}]"
    mail(to: 'mvsicio@gmail.com', subject: subject)
  end
end
