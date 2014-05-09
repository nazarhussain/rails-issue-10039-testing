require 'test_helper'

class NotificationControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
  end

  test "should get send_notification" do
    get :send_notification
    assert_response :success
  end

end
