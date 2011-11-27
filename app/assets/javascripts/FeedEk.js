(function($){$.fn.FeedEk=function(opt){
  var def={FeedUrl:'',MaxCount:5,ShowDesc:true,ShowPubDate:true};
  if(opt){$.extend(def,opt)}
  var idd=$(this).attr('id');
　if(def.FeedUrl==null||def.FeedUrl==''){
    $('#'+idd).empty();
    return
  }
  var pubdt;
  $('#'+idd).empty().append('<div style="text-align:left; padding:3px;"><img src="/assets/loader.gif" /></div>');
  $.ajax({
    url:'http://ajax.googleapis.com/ajax/services/feed/load?v=1.0&num='+def.MaxCount+'&output=json&q='+encodeURIComponent(def.FeedUrl)+'&callback=?',dataType:'json',
    success:function(data){
      $('#'+idd).empty();
      $.each(data.responseData.feed.entries,function(i,entry){
        if(def.ShowPubDate){
          pubdt = new Date(entry.publishedDate);
          $('#'+idd).append('<div class="ItemDate">'+ toFormatedString(pubdt)+'</div>')
        }

        $('#'+idd).append('<div class="ItemTitle"><a href="'+entry.link+'" target="_blank" >'+entry.title+'</a></div>');
        if(def.ShowDesc)$('#'+idd).append('<div class="ItemContent">'+entry.content+'</div>')
       })}})
}})(jQuery);

function toFormatedString(date){
  yy = date.getYear();
  mm = date.getMonth() + 1;
  dd = date.getDate();
  if (yy < 2000) { yy += 1900; }
  if (mm < 10) { mm = "0" + mm; }
  if (dd < 10) { dd = "0" + dd; }
  return yy + "/" + mm + "/" + dd;
}

