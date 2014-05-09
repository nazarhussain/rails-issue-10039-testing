class NotificationController < ApplicationController
  def index
  end

  def send_notification
    30.times { |num| NotificationMailer.delay.welcome("#{num} Notification # #{Random.rand(1000)}") }
    render nothing: true
  end
end
