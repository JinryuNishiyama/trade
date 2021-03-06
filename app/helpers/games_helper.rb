module GamesHelper
  def keyword(*columns)
    words = []
    (0..columns.size - 1).each do |index|
      words[index] = params[:q][columns[index]] if params[:q]
    end
    words.compact.join(",")
  end

  def generate_link(text, game)
    reply_to = text.slice(/>>[0-9]+/)
    if reply_to
      reply_to_num = reply_to.slice(/[0-9]+/)
      link = link_to reply_to,
        game_path(game, anchor: "chat-list-item-#{reply_to_num}"),
        class: "chat-reply-link"
    end
    content = text.sub(/>>[0-9]+/, "")
    [link: link, content: content]
  end
end
