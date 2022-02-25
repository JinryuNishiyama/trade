$(document).on("turbolinks:load", function(){
  $(".chat-reply-button").click(function(){
    $(".chat-text-area").focus();
    let index = $(this).parent().find("h3 span").text();
    $(".chat-text-area").val(">>" + index + "\n");
  });
});
