$(document).on("turbolinks:load", function(){
  $(".header-logged-in").click(function(){
    $(".header-box").slideToggle();
  });
});
