class MessagesController < ApplicationController
  def index
    @messages = Message.order(created_at: "desc")
  end

  def new
    @message = Message.new
  end

  def create
    @message = Message.new params.require(:message).permit(:text)
    @message.user = current_user

    respond_to do |format|
      if @message.save
        format.turbo_stream {
          render turbo_stream: turbo_stream.prepend("messages", partial: "message", locals: { message: @message })
        }
      else
        render :index, status: :unprocessable_entity
      end
    end
  end
end
