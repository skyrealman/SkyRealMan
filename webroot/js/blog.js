$(function(){
  $(".dropdown-menu li a").click(function(){
    $("#addTag").text($(this).text());
    $("#addTag").val($(this).text());
  });
  $(".table tbody th #tagdelete").click(function(){
        $("#deleteTagModal").modal('show');
        $("#del").attr("href", "/admin/manage/delete/" + $(this).attr("abc"));
  });
  $(".table tbody th #tagedit").click(function(){
        $("#editTagModal").modal('show');
        var abc = $(this).attr("abc");
        $("#edit").click(function(){
        $("#edit").attr("href", "/admin/manage/edit/" + abc + "/" + $("#newTag").val());
        });
        
  });
  $(".table tbody th #storyedit").click(function(){
        $.getJSON($(this).attr("href"), function(data){
            location.href = "/admin/prepare";
            $("#storytitle").val(data.title);
        });
  });
});

