class MessagesController < ApplicationController
  before_action :set_message, only: %i[ show edit update destroy ]

  def index
    @messages = Message.all
  end

  def show
  end

  def new
    @message = Message.new
  end

  def edit
    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: turbo_stream.update(@message, partial: "messages/form", locals: {message: @message})
      end
    end
  end
  def create
    @message = Message.new(message_params)

    respond_to do |format|
      if @message.save
        format.turbo_stream do
          render turbo_stream:[
            turbo_stream.update('new_message', partial: "messages/form", locals: {message: Message.new}),
            turbo_stream.prepend('messages', partial: "messages/message", locals: {message: @message}),
            turbo_stream.update('message-counter',Message.count),
            turbo_stream.update('notice', "message #{@message.id} created")
          ]
        end
      else
        format.turbo_stream do
          render turbo_stream:[
            turbo_stream.update('new_message', partial: "messages/form", locals: {message: @message})
          ]
        end
      end
    end
  end

  def update
    respond_to do |format|
      if @message.update(message_params)
        format.turbo_stream do
          render turbo_stream: [
            turbo_stream.update(@message, partial: "messages/message", locals: {message: @message}),
           turbo_stream.update('notice', "message #{@message.id} updated")
        ]
        end
      else
        format.turbo_stream do
          render turbo_stream: turbo_stream.update(@message, partial: "messages/form", locals: {message: @message})
        end
      end
    end
  end

  def destroy
    @message.destroy
    respond_to do |format|
     format.turbo_stream do
        render turbo_stream: [
          turbo_stream.remove(@message),
          turbo_stream.update('message-counter',Message.count)
        ]
      end
    end
  end

  private
    def set_message
      @message = Message.find(params[:id])
    end

    def message_params
      params.require(:message).permit(:body)
    end
end
