require 'test_helper'

class OrderMailerTest < ActionMailer::TestCase
  test "delivered" do
    mail = OrderMailer.delivered
    assert_equal "Delivered", mail.subject
    assert_equal ["to@example.org"], mail.to
    assert_equal ["from@example.com"], mail.from
    assert_match "Hi", mail.body.encoded
  end

end
