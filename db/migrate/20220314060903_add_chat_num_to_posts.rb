class AddChatNumToPosts < ActiveRecord::Migration[6.1]
  def change
    add_column :posts, :chat_num, :integer
  end
end
