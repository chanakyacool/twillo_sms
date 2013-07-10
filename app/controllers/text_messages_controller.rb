class TextMessagesController < ApplicationController

  # twilio account information
  TWILIO_NUMBER = "+12675923385"
  ACCOUNT_SID = 'AC47e4cc9d9bcb0f4d4272b6332192d327'
  AUTH_TOKEN = 'c93d7406b5e04ae7ea65214a57e1edbe'

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

        logger.info "sending message: #{@text_message.message} to: #{number}"

        begin
          account.sms.messages.create(
              :from => TWILIO_NUMBER,
              :to => "+91#{number}",
              :body => @text_message.message
          )
          successes << "#{number}"
        rescue Exception => e
          logger.error "error sending message: #{e.to_s}"
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
