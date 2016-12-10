$(function(){
  $(".dropdown-menu li a").click(function(){
    $("#addTag").text($(this).text());
    $("#addTag").val($(this).text());
  });
});
$(document).ready(function(){
   var myDate = new Date();
   $("#year").text(myDate.getYear() + 1900);
});
