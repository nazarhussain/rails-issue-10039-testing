class NotificationMailer < ActionMailer::Base
  default from: "from@example.com"

  def welcome(message)
    @message = message
    @teams = Team.where("title like '%#{message}%'")
    mail(to: "test-user@test.com", subject: "Rails Deadlock Issue")
  end
end
