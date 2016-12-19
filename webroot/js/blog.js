$(function(){
  $(".dropdown-menu li a").click(function(){
    $("#addTag").text($(this).text());
    $("#addTag").val($(this).text());
  });
  $(".table tbody th #tagedit").click(function(){
        console.log($(this).attr("abc"));
        $("#deleteTagModal").modal('show');
        $("#del").attr("href", "/admin/manage/delete/" + $(this).attr("abc"));
  });
});


