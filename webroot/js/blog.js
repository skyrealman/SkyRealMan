$(function(){
  $(".dropdown-menu li a").click(function(){
    $("#addTag").text($(this).text());
    $("#addTag").val($(this).text());
  });
  $(".table tbody th #tagedit").click(function(){
     $("#deleteTagModal").modal('show')
  });
});


