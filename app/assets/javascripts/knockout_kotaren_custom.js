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


function _decorate_br_tag( text ){
	var br_text = text.replace(/\n/g,
		function(){
      return '<br>';
		});
	return br_text;
}

function _decorate_link_tag( text ){
	var linked_text = text.replace(/(\[(.+?)\])?[\(]?((https?|ftp)(:\/\/[-_.!~*\'a-zA-Z0-9;\/?:\@&=+\$,%#]+)|blog\?id=[^\)]+)[\)]?/g,
		function(){
			var matched_link = arguments[3];
			if ( matched_link.match(/(\.jpg|\.jpeg|\.gif|\.png|\.bmp)[?]?/i)){
				return matched_link;
			}else if ( matched_link.match(/https:\/\/open\.spotify\.com/)){
        var spotify_uri = matched_link.replace(/https:\/\/open\.spotify\.com/,'');
        spotify_uri = spotify_uri.replace(/\//g,'%3A');
        var spotify_embed = '<iframe src="https://embed.spotify.com/?uri=spotify' + spotify_uri  +'" width="100%" height="380" frameborder="0" allowtransparency="true"></iframe>';
				var spotify_link = '<a href="' + matched_link + '" target="_blank" >' + matched_link + '</a>';
        return spotify_embed + '<br>' + spotify_link;
      }else{
				var title_text = arguments[2] ? arguments[2] : matched_link;
				return '<a href="' + matched_link + '" target="_blank" >' + title_text + '</a>';
			}
		});
	return linked_text;
}
