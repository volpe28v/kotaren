// for jQuery mobile initialize
$(document).bind("mobileinit", function(){
  $.extend( $.mobile, {
    ajaxEnabled: false
  });
});

$(document).ready(function(){ 
  // この数値以上、横スワイプしたときにイベントを発生
  $.event.special.swipe.horizontalDistanceThreshold = 60; 

  // フリック・スワイプ画面遷移
  $(".swipe_back").bind("swiperight", function(){
    history.back();
  }); 
});


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
    $('#tune_progress_' + tune_id ).progressBar( next_val , this.option );

    this.update_remote(user_id, tune_id,next_val);
  },

  update_remote : function(user_id, tune_id, val){
    $('#tune_list_ul').prepend($('#id_' + tune_id));

    $.ajax({
      type: "GET",
      cache: false,
      url: "/users/" + user_id + "/tunes/update_progress",
      data: "tune_id=" + tune_id + "&progress_val=" + val,
      dataType: "jsonp"

    });
  }
}

var updateProgressTimerID = 0;
function updateProgress(data){
  updateElem('#progress_updated_at_' + data.id, data.date)
  updateElem('#tune_list_progress_updated_at_' + data.id, data.mini_date)
  updateElem('#progress_title_' + data.id, data.comment_title + " by " + data.comment_name + " at " + data.comment_date )
  updateElem('#progress_word_' + data.id, comment_decorater(data.comment_text) )

  clearTimeout(updateProgressTimerID);
  $('#progress_response_' + data.id).fadeIn('slow',function(){
    updateProgressTimerID = setTimeout(function(){
      $('#progress_response_' + data.id).fadeOut('slow');
    },10000);
  });
}

function loadTuneList(user_id){
  $.ajax({
    type: "GET",
    cache: false,
    url: "/users/" + user_id + "/tunes/load_tune_list",
    dataType: "jsonp"
  });
}

function showTuneList(data){
  $('#tune_list_ul').hide();
  $('#tune_list_ul').append(data.lists);
  $('#tune_list_ul').listview('refresh');
  $("#tune_list .progress-bar").each(function(){
    $(this).progressBar(progress_default_option);
  });
  $('#tune_list_loading').remove();
  $('#tune_list_ul').fadeIn();
}

function loadAlbumList(user_id){
  $.ajax({
    type: "GET",
    cache: false,
    url: "/users/" + user_id + "/albums/load_album_list",
    dataType: "jsonp"
  });
}

function showAlbumList(data){
  $('#album_list_ul').hide();
  $('#album_list_ul').append(data.lists);
  $('#album_list_ul').listview('refresh');
  $("#album_list .progress-bar").each(function(){
    $(this).progressBar(progress_default_option);
  });
  $('#album_list_ul').delegate('a', 'click',function(){
    $('.tune_li').hide();
    $('.album_' + $(this).data('id')).show();
  });
  $('#album_list_loading').remove();
  $('#album_list_ul').fadeIn();

//TODO: 曲リストが無ければロードする必要がある
}

function loadTuningList(user_id){
  $.ajax({
    type: "GET",
    cache: false,
    url: "/users/" + user_id + "/tunings/load_tuning_list",
    dataType: "jsonp"
  });
}

function showTuningList(data){
  $('#tuning_list_ul').hide();
  $('#tuning_list_ul').append(data.lists);
  $('#tuning_list_ul').listview('refresh');
  $('#tuning_list_ul').delegate('a', 'click', function(){
    $('.tune_li').hide();
    $('.tuning_' + $(this).data('id')).show();
  });
  $('#tuning_list_loading').remove();
  $('#tuning_list_ul').fadeIn();

//TODO: 曲リストが無ければロードする必要がある
}

function loadTune(user_id, tune_id){
  $.ajax({
    type: "GET",
    cache: false,
    url: "/users/" + user_id + "/tunes/load_tune",
    data: "tune_id=" + tune_id,
    dataType: "jsonp"
  });
}

function showTune(data){
  $('#tune_body_' + data.id).hide();
  $('#tune_body_' + data.id).append(data.tune);
  $('#tune_body_' + data.id).trigger('create');
  $('#tune_loading_' + data.id).remove();
  $('#tune_body_' + data.id).fadeIn();

  $('#tune_' + data.id + ' .progress-bar').each(function(){
    $(this).progressBar(progress_default_option);
  });

  $('#tune_' + data.id).delegate('.same-tuning-btn', 'click', function(){
    $('.tune_li').hide();
    $('.tuning_' + $(this).data('tuning')).show();
  });

  $('#tune_' + data.id).delegate('.tune-album-img', 'click', function(){
    $('.tune_li').hide();
    $('.album_' + $(this).data('id')).show();
  });

  $('#tune_' + data.id).delegate('.add-comment-button', 'click', function(){
    var text_area = $('#tune_' + data.id).find('.add-comment-form-msg');
    $.ajax({
      type: "POST",
      cache: false,
      url: "/users/" + data.user_id + "/tunes/" + data.id + "/comments/ajax_create",
      data: "comment=" + text_area.val(),
      dataType: "jsonp"
    });

    text_area.val("");
  });
}

function addComment(data){
  var $new_comment = $('<div/>').attr("id", "comment_" + data.comment_id)
                                .attr("style","display:none")
  .append(
    $('<dl/>').append(
      $('<dt/>').append(
        $('<div/>').addClass("comment-date").html(data.date))))
  .append(
    $('<dl/>').append(
     $('<dd/>').append(
       $('<div/>').addClass("comment-text").html(comment_decorater(data.comment)))));

  $('#tune_' + data.id).find('.comment-area')
    .prepend($new_comment);
  $new_comment.fadeIn();
}

function comment_decorater(text){
  var deco_text = text.replace(/((https?|ftp)(:\/\/[-_.!~*\'()a-zA-Z0-9;\/?:\@&=+\$,%#]+))/g,
    function(){
      var matched_link = arguments[1];
        if ( matched_link.match(/(\.jpg|\.gif|\.png|\.bmp)$/)){
          return '<img src="' + matched_link + '"/>';
        }else{
          return '<a href="' + matched_link + '" target="_blank" >' + matched_link + '</a>';
        }
      });
  deco_text= deco_text.replace(/\n/g,'<br/>');

  return deco_text;
}

function loadCommentList(){
  $.ajax({
    type: "GET",
    cache: false,
    url: "/comments/load_comment_list",
    dataType: "jsonp"
  });
}

function showCommentList(data){
  $('#comment_list_area').hide();
  $('#comment_list_area').append(data.lists);
  $('#comment_list_area').trigger('create');
  $('#comment_list_loading').remove();

  $("#comment_list_area .progress-bar").each(function(){
    $(this).progressBar(progress_default_option);
  });

  $('#comment_list_area').fadeIn();

  $('#comment_list_area').delegate('.add-reply-button', 'click', function(){
    var text_area = $('#comment_' + $(this).data("id")).find('.add-reply-form-msg');
    $.ajax({
      type: "POST",
      cache: false,
      url: "/comments/" + $(this).data("id") + "/ajax_create_reply",
      data: "reply=" + text_area.val(),
      dataType: "jsonp"
    });

    text_area.val("");
  });
}

function addReply(data){
  var $new_reply = $('<div/>').attr("id", "reply_" + data.reply_id)
                                .attr("style","display:none")
  .append(
    $('<dl/>').append(
      $('<dt/>').append(
        $('<div/>').addClass("comment-date").html(data.date + " " + data.name)))
    .append(
      $('<dd/>').append(
        $('<div/>').addClass("comment-text").append(
          $('<p/>').html(comment_decorater(data.reply))))));

  $('#comment_reply_' + data.id).prepend($new_reply);
  $new_reply.fadeIn();
}


