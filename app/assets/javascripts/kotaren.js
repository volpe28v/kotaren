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
      type: "GET",
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

    $(that).youtubin({
      swfWidth : 200,
      swfHeight : 180
    });
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

    var data = {reply: text_area.val()};
    $.ajax({
      type: "POST",
      cache: false,
      url: "/comments/" + $(this).data("id") + "/replies",
      data: data,
      dataType: "jsonp"
    });

    text_area.val("");
  });
}

function addReply(data){
  var $new_reply = $('<div/>')
    .attr("id", "reply_" + data.reply_id)
    .attr("style","display:none")
    .append($('<dl/>')
      .append($('<dt/>')
        .append($('<span/>').html(data.date))
        .append($('<div/>').addClass("comment-name").html("by ")
          .append($('<a/>').attr("href",data.user_url).html(data.name))))
      .append($('<dd/>')
        .append($('<div/>').addClass("comment-text")
          .append($('<p/>').html(data.reply.replace(/\n/g,"<br>"))))
        .append($('<div/>').addClass("comment-destroy")
          .append($('<a/>').attr("href", data.destroy_url)
                           .attr("data-confirm","本当に削除しますか？")
                           .attr("data-method","delete")
                           .attr("data-remote","true")
                           .attr("rel","nofllow")
                           .html("x")))
        .append($('<br/>'))));

  $('#replies').prepend($new_reply);
  $new_reply.fadeIn();
}

