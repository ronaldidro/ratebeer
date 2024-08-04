class Message < ApplicationRecord
  belongs_to :user

  def formatted_date
    created_at.strftime("%d-%m-%Y %H:%M")
  end

  after_create_commit -> { broadcast_prepend_to "messages_index", partial: "messages/message", target: "messages" }
end
