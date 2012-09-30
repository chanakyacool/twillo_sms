require 'test_helper'

class TextMessageTest < ActiveSupport::TestCase

  # called before every single test
  def setup
    msg = "Test message sent from text_messages_controller_test"
    msg_long = "This message is just way too long.  The max is 160.  I don't know why someone would write a message this long in a text message.  Seems like it would be more appropriate in an email or some other form of correspondence."

    @empty = TextMessage.new({})
    @one = TextMessage.new({numbers: "6509315895", message: msg})
    @one_formatted = TextMessage.new({numbers: "(650) 931-5895", message: msg})
    @one_invalid = TextMessage.new({numbers: "23", message: msg})
    @two_valid = TextMessage.new({numbers: "1111111111, 3333333333", message: msg})
    @two_invalid = TextMessage.new({numbers: "23, 55invalid", message: msg})
    @message_too_long = TextMessage.new({numbers: "6509315895", message: msg_long})
    @duplicate = TextMessage.new({numbers: "1111111111, 1111111111, 3333333333, (333) 333-3333", message: msg})
  end

  test "text_message attributes must not be empty" do
    assert @empty.invalid?
    assert @empty.errors[:numbers].any?
    assert @empty.errors[:message].any?
  end

  test "text_message should accept valid numbers" do
    assert @one.valid?
    assert @one_formatted.valid?
    assert @two_valid.valid?
  end

  test "text_message should reject invalid numbers" do
    assert @one_invalid.invalid?
    assert @two_invalid.invalid?
  end

  test "text_message should reject messages > 160" do
    assert @message_too_long.invalid?
    assert @message_too_long.errors[:numbers].empty?
    assert @message_too_long.errors[:message].any?
  end

  test "text_message should remove duplicates" do
    assert @duplicate.valid?
    assert_equal 2, @duplicate.numbers_array.count
  end

end
