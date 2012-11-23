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
  updateElem('#progress_title_' + data.id, data.title + " by " + data.name )
  updateElem('#progress_word_' + data.id, data.comment )

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
  $('#tune_list_ul').fadeIn();
}

function loadAlbumList(user_id){
  $.ajax({
    type: "GET",
    cache: false,
    url: "/users/" + user_id + "/tunes/load_album_list",
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
  $('#album_list_ul').fadeIn();

//TODO: 曲リストが無ければロードする必要がある
}

function loadTuningList(user_id){
  $.ajax({
    type: "GET",
    cache: false,
    url: "/users/" + user_id + "/tunes/load_tuning_list",
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
}

