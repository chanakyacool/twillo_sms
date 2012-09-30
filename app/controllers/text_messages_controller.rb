class TextMessagesController < ApplicationController

  # twilio account information
  TWILIO_NUMBER = "+16504580016"
  ACCOUNT_SID = 'ACa38f9dc5f795d5664682b91144f05f49'
  AUTH_TOKEN = 'd46693f8612922904306c4ea9acf5629'

  # GET /text_messages/new
  def new
    @text_message = TextMessage.new
    render :new
  end

  # POST /text_messages
  def create
    @text_message = TextMessage.new(params[:text_message])

    if @text_message.valid?

      successes = []
      errors = []
      numbers = @text_message.numbers_array
      account = Twilio::REST::Client.new(ACCOUNT_SID, AUTH_TOKEN).account
      numbers.each do |number|

        begin
          account.sms.messages.create(
              :from => TWILIO_NUMBER,
              :to => "+1#{number}",
              :body => @text_message.message
          )
          successes << "#{number}"
        rescue Exception => e
          errors << e.to_s
        end
      end

      flash[:errors] = errors
      flash[:successes] = successes
      if (flash[:errors].any?)
        render :action => :status, :status => :bad_request
      else
        render :action => :status
      end

    else
      render :action => :new, :status => :bad_request
    end
  end

end
