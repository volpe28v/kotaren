ko.bindingHandlers.commentHtml = {
  init: function(element, valueAccessor, allBindings, viewModel, bindingContext) {
    return { 'controlsDescendantBindings': true };
  },
  update: function (element, valueAccessor, allBindings, viewModel, bindingContext) {
    var text = ko.unwrap(valueAccessor());
    text = _decorate_link_tag(text);
    text = _decorate_br_tag(text);

    $(element).html(text);
    ko.applyBindingsToDescendants(bindingContext, element);
  }
}

// autofit カスタムバインディング(true の場合に有効)
ko.bindingHandlers.autofit = {
  init: function(element, valueAccessor, allBindings, viewModel, bindingContext) {
    $(element).autofit({min_height: 60});
  },
  update: function(element, valueAccessor, allBindings, viewModel, bindingContext) {
    if (ko.unwrap(valueAccessor()) == ""){
      setTimeout(function(){
        $(element).trigger('keyup');
      }, 1);
    }
  }
}

function _decorate_br_tag( text ){
	var br_text = text.replace(/\n/g,
		function(){
      return '<br>';
		});
	return br_text;
}

function _decorate_link_tag( text ){
  var build_youtube_link = function(id, link){
    var youtube_embed = '<div class="video"><iframe width="560" height="315" src="https://www.youtube.com/embed/' + id + '?autoplay=0&rel=0&showinfo=0&autohide=1" frameborder="0" allowfullscreen></iframe></div>';
    var youtube_link = '<a href="' + link + '" target="_blank" >' + link + '</a>';
    return youtube_embed + '<br>' + youtube_link;
  }

	var linked_text = text.replace(/(\[(.+?)\])?[\(]?((https?|ftp)(:\/\/[-_.!~*\'a-zA-Z0-9;\/?:\@&=+\$,%#]+)|blog\?id=[^\)]+)[\)]?/g,
		function(){
      var matched_link = arguments[3];
      if ( matched_link.match(/(\.jpg|\.jpeg|\.gif|\.png|\.bmp)[?]?/i)){
        return matched_link;
      }else if ( matched_link.match(/https?:\/\/open\.spotify\.com/)){
        // Spotify
        var spotify_uri = matched_link.replace(/https:\/\/open\.spotify\.com/,'');
        spotify_uri = spotify_uri.replace(/\//g,'%3A');
        var spotify_embed = '<iframe src="https://embed.spotify.com/?uri=spotify' + spotify_uri  +'" width="100%" height="380" frameborder="0" allowtransparency="true"></iframe>';
				var spotify_link = '<a href="' + matched_link + '" target="_blank" >' + matched_link + '</a>';
        return spotify_embed + '<br>' + spotify_link;
      }else if ( matched_link.match(/https?:\/\/www\.youtube\.com\/watch\?v=/)){
        // Youtube
        var youtube_id = matched_link.replace(/https?:\/\/www\.youtube\.com\/watch\?v=([_\-0-9a-zA-Z]+).*/, function(){
          return arguments[1];
        });
        return build_youtube_link(youtube_id, matched_link);
      }else if ( matched_link.match(/https?:\/\/youtu\.be/)){
        // Youtube
        var youtube_id = matched_link.replace(/https?:\/\/youtu\.be\/([_\-0-9a-zA-Z]+).*/, function(){
          return arguments[1];
        });
        return build_youtube_link(youtube_id, matched_link);
      }else if ( matched_link.match(/https?:\/\/instagram.com\/p/)){
        // Instagram
        var instagram_id = matched_link.replace(/https?:\/\/instagram.com\/p\/([_\-0-9a-zA-Z]+).*/, function(){
          return arguments[1];
        });
        var instagram_embed = '<iframe width="100%" height="100%" src="https://instagram.com/p/' + instagram_id + '/embed" frameborder="0" allowfullscreen></iframe>';
				var instagram_link = '<a href="' + matched_link + '" target="_blank" >' + matched_link + '</a>';
        return instagram_embed + '<br>' + instagram_link;
      }else{
        var title_text = arguments[2] ? arguments[2] : matched_link;
        return '<a href="' + matched_link + '" target="_blank" >' + title_text + '</a>';
			}
		});
	return linked_text;
}


