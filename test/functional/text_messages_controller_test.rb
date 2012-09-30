require 'test_helper'

class TextMessagesControllerTest < ActionController::TestCase

  @test_msg = "TextMessagesControllerTest test message"

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should get bad_request when invalid text_message" do
    post :create, text_message: { message: @test_msg, numbers: "23invalid" }

    assert_response :bad_request
  end

  # disabled because it costs $0.01 to run
  #test "should get success when valid text_message" do
  #  valid = text_messages(:one)
  #  post :create, text_message: { message: @test_msg, numbers: "6509315895" }
  #  assert_response :success
  #end

end
