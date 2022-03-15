$(document).on("turbolinks:load", function(){
  $(".chat-reply-button").click(function(){
    $(".chat-text-area").focus();
    let chat_num = $(this).parent().parent().parent().find("h3 span").text();
    $(".chat-text-area").val(">>" + chat_num + "\n");
  });
});
