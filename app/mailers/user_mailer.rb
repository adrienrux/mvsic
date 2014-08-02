class UserMailer < ActionMailer::Base
  default from: 'mvsicio@gmail.com'

  def schedule_email(email, schedule)
    @festival = schedule.festival
    @url  = "http://mvsic.io/schedules/#{schedule.hashed_id}"
    @email = email
    subject = "Here's your Schedule for #{schedule.festival.name}!"
    puts 'Hello'
    mail(to: email, subject: subject)
  end
end
