$(function($){
  $('#tunes_list_form')
    .bind("ajax:success", function(xhr, data){
      $('#loading').hide();
      data.tunes.forEach(function(tune){
        $("#tune_" + tune.id).appendTo("#tune_list_table");
        $("#tune_" + tune.id).show();
      });
      updateElem('#touched_num', data.touched_count)
      updateElem('#doing_num', data.doing_count)
      updateElem('#done_num', data.done_count)
      $("#tune_list_table").fadeIn("slow");
    }
  );
});

function loadTunes(){
  $('#update_tunes').click();
  $('.tune-tr').hide();
  $('#loading').show();
}

function updateElem(id, html){
  if ( $(id).html() == html ){return}

  $(id).hide();
  $(id).empty();
  $(id).html(html);
  $(id).fadeIn();
}

var progress_default_option = {
    steps           : 0,
    stepDuration    : 0,
    max             : 100,
    showText        : true,
    textFormat      : 'percentage',
    width           : 120,
    height          : 12, 
    callback        : null,
    boxImage        : '/assets/progress/progressbar.gif',
    barImage        : { 
        0:   '/assets/progress/progressbg_red.gif',
        30:  '/assets/progress/progressbg_orange.gif',
        60:  '/assets/progress/progressbg_yellow.gif',
        100: '/assets/progress/progressbg_green.gif'
    } 
}

var progress_controller = {
  step : 10,
  option : { steps : 20, stepDuration : 20 },

  up : function (user_id, tune_id){
    this.move_bar(user_id, tune_id, function (current_val, step){
      return current_val + step;
    });
  },

  down : function (user_id, tune_id){
    this.move_bar(user_id, tune_id, function (current_val, step){
      return current_val - step;
    });
  },

  play : function (user_id, tune_id){
    this.move_bar(user_id, tune_id, function (current_val, step){
      return current_val + 1;
    });
  },

  touch_bar : function ( user_id, tune_id ){
    var current_val = Number($('#progress_' + tune_id + '_pbText').html().replace("%",""))
    this.update_remote(user_id, tune_id,current_val);
  },


  move_bar : function ( user_id, tune_id, move_callback ){
    var current_val = Number($('#progress_' + tune_id + '_pbText').html().replace("%",""))
    var next_val = move_callback(current_val, this.step);
    if (next_val > 100){ 
      next_val = 100; 
    }else if (next_val < 0){ 
      next_val = 0; 
    }
    $('#progress_' + tune_id ).progressBar( next_val , this.option );

    this.update_remote(user_id, tune_id,next_val);
  },

  update_remote : function(user_id, tune_id, val){
    var data = { 
      tune_id: tune_id,
      progress_val: val
    };
    $.ajax({
      type: "POST",
      cache: false,
      url: "/users/" + user_id + "/tunes/update_progress",
      data: data
    });
  }
}

// youtubinへのラッパー
var applyYoutubin = function(){
  var link_id = 0;

  function doYoutubin(that){
    $(that).attr("id", "comment_link_" + link_id);
    link_id += 1;

    loadSpecificYoutube($(that).attr("href"), $(that));
  }
 
  return function(id){
    $(id + "[href*='www.youtube.com']").each(function(){ doYoutubin(this); });
    $(id + "[href*='m.youtube.com']").each(function(){ doYoutubin(this); });
    $(id + "[href*='youtu.be']").each(function(){ doYoutubin(this); });
  }
}();

function showComment(){
  $('#comments').delegate('.add-reply-button', 'click', function(){
    var text_area = $('#comments').find('.add-reply-form-msg');
    if ( text_area.val() == "" ){ return; }

    var data = {text: text_area.val()};
    $.ajax({
      type: "POST",
      cache: false,
      url: "/comments/" + $(this).data("id") + "/replies",
      data: {reply: data},
      dataType: "json",
      success: function (data) {
        var $new_reply = $('<div/>').html(data.html).css('display','none');
        $('#replies').prepend($new_reply);
        applyYoutubin("#reply_" + data.id + " a");
        $new_reply.fadeIn();
      }
    });

    text_area.val("");
    text_area.trigger('keyup');
  });
}

function showCommentOnTune(){
  $('#comments').delegate('.add-comment-button', 'click', function(){
    var text_area = $('#comments').find('.add-comment-form-msg');
    if ( text_area.val() == "" ){ return; }

    var data = {text: text_area.val()};
    $.ajax({
      type: "POST",
      cache: false,
      url: $(this).data("url"),
      data: {comment: data},
      dataType: "json",
      success: function (data) {
        var $new_comment = $('<div/>').html(data.html).css('display','none');
        $('#my_comments').prepend($new_comment);
        applyYoutubin("#comment_" + data.id + " a");
        $new_comment.fadeIn();
      }
    });

    text_area.val("");
    text_area.trigger('keyup');
  });
}

function loadYoutube(tune_name)
{
  $.ajax({
    dataType: "jsonp",
    data: {
      "vq": "押尾コータロー " + tune_name,
      "orderby": "relevance",
      "start-index": 1,
      "max-results": 12,
      "alt":"json-in-script"
    },
    cache: false,
    url: "http://gdata.youtube.com/feeds/api/videos",
    success: function (data) {
      $.each(data.feed.entry, function(i,item){
        var group = item.media$group;

         var youtube_link_a = $("<a/>").attr("href",group.media$player[0].url).attr("title","").addClass("prettyPhoto").prettyPhoto();
         var thumb_div = $("<div/>").addClass("thumbnail-video ui-widget-content ui-corner-all")
           .append($("<img/>").attr("src", group.media$thumbnail[0].url)).append("<br/")
           .append(item.title.$t).append("<br/>") 
           .append(item.author[0].name.$t).append("<br/>") 
           .append($("<span/>").addClass("info").text("再生回数：" + ((item.yt$statistics == null) ? "0" : item.yt$statistics.viewCount)));
         
         youtube_link_a.append(thumb_div).appendTo("#ref-videos");
        
      });
    }
  });
}

function loadSpecificYoutube(url, $target)
{
  var videoID = $.url(url).param().v;
  if ( videoID == undefined || videoID == ""){
    videoID = url.replace("http://youtu.be/","");
  }

  $.ajax({
    dataType: "jsonp",
    cache: false,
    url: "http://gdata.youtube.com/feeds/api/videos/" + videoID,
    success: function (data) {
      var json = $.xml2json(data);
      var item = json;
      var group = item.group;

      var youtube_link_a = $("<a/>").attr("href",group.player.url).attr("title","").addClass("prettyPhoto").prettyPhoto();
      var thumb_div = $("<div/>").addClass("thumbnail-video-comment ui-widget-content ui-corner-all")
        .append($("<img/>").attr("src", group.thumbnail[0].url)).append("<br/")
        .append(item.title).append("<br/>") 
        .append(item.author.name).append("<br/>") 
        .append($("<span/>").addClass("info").text("再生回数：" + ((item.statistics == null) ? "0" : item.statistics.viewCount)));
        
      $target.before(youtube_link_a.append(thumb_div));
    }
  });
}
