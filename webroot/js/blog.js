$(function(){
  $(".dropdown-menu li a").click(function(){
    $("#addTag").text($(this).text());
    $("#addTag").val($(this).text());
  });
  $(".table tbody th #tagdelete").click(function(){
        $("#deleteTagModal").modal('show');
        $("#del").attr("href", "/admin/tagmanage/delete/" + $(this).attr("abc"));
  });
  $(".table tbody th #tagedit").click(function(){
        $("#editTagModal").modal('show');
        var abc = $(this).attr("abc");
        $("#edit").click(function(){
        $("#edit").attr("href", "/admin/tagmanage/edit/" + abc + "/" + $("#newTag").val());
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
        var str = $("#storybody").val() + "<img class='img-responsive aligncenter' src='" + response.file[0].filePath + "' width='80%' />"
        $("#storybody").val(str)
    })
  $("#search").click(function(){
                     $("#flash").html("");
                     $("#loading").show();
                     NProgress.start();
                     var keys = $("#searchtext").val();
                     $.get("/search/"+keys, function(data){
                           if(data.flash != null){
                                var content = "<div id='alert' class = 'alert alert-danger' role = 'alert'>" + data.flash + "</div>"
                                $("#flash").append(content)
                           }else{
                                var res = ""
                                $("#bloglist").text("")
                           $("#bloglist").append("<ol class='breadcrumb'><li><a href='/'>首页</a></li><li class= 'active'>搜索结果</li></ol>")
                                for(var p in data["results"]){
                                var tmp = "http://" + window.location.host + "/story/" + data["results"][p].stitlesanitized
                                var location = tmp.substring(0, 50) + "...  " + data["results"][p].sposttime
                                res += "<ul>"
                                res += "<a href='/story/"+ data["results"][p].stitlesanitized + "/with/" + $.base64.encode(keys) + "'>" + data["results"][p].stitle + "</a><br>"
                                res += "<span id='result'>" + data["results"][p].sbody + "</span><br>"
                                res += "<span id='location'>" + location +"</span></ul>"
                                res += "<hr>"
                                console.log(keys)
                                console.log($.base64.encode(keys))
                                }
                                $("#bloglist").append(res)
                                }
                          
                           NProgress.done();
                           $("#loading").hide();
                           })

  });
});

