class UserMailer < ActionMailer::Base
  default from: 'mvsicio@gmail.com'

  def schedule_email(user, schedule)
    @schedule = schedule
    @festival = schedule.festival
    @user = user
    subject = "Here's your Schedule for #{schedule.festival.name}!"
    mail(to: @user.email, subject: subject)
  end
end
