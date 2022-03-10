$(document).on("turbolinks:load", function(){
  $(".show-user-posted-chat-button").click(function(){
    $(".show-user-liked-chat").hide();
    $(".show-user-posted-chat").show();
  });
  $(".show-user-liked-chat-button").click(function(){
    $(".show-user-posted-chat").hide();
    $(".show-user-liked-chat").show();
  });
});
