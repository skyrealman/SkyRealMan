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
  $(".table tbody th #storydel").click(function(){
        $("#deleteStoryModal").modal('show')
        $("#del").attr("href", "/admin/storymanage/delete/" + $(this).attr("abc"));
  });
  $("#inputbutton").fileinput({
        showUpload: true,
        showRemove: true,
        dropZoneEnabled: false,
        language: "zh",
        maxFileCount: 5,
        allowedFileExtensions: ["jpg", "png", "gif"],
        uploadUrl: "/admin/upload",
    });
  $("#inputbutton").on("fileuploaded", function(event, data, previewId, index){
        var form = data.form, files = data.files, extra = data.extra, response = data.response, reader = data.reader
        var value = response.file[0].fileSize + "|" + response.file[0].fileName + "|" + response.file[0].fileUID
        var content = "<input type='hidden' name='file"
        content += index + "' value='"
        content += value
        content += "'>"
        $("#attachdata").append(content)
        var str = $("#storybody").val() + "<img src='" + response.file[0].filePath + "' class='aligncenter' width='600'/>"
        $("#storybody").val(str)
    })
});

