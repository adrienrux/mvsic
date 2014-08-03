class UserMailer < ActionMailer::Base
  default from: 'mvsicio@gmail.com'

  def schedule_email(email, schedule)
    @schedule = schedule
    @festival = schedule.festival
    @email = email
    subject = "Here's your Schedule for #{schedule.festival.name}!"
    puts 'Hello'
    mail(to: email, subject: subject)
  end
end
