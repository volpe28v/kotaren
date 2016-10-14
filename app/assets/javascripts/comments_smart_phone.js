ons.ready(function(){
  ons.disableAutoStyling();
  document.querySelector('ons-navigator').pushPage('detailsComment.html');
});

window.ons.NavigatorElement.rewritables.link = function(element, target, options, callback) {
  var viewModel = new DetailsCommentViewModel(CommentID);
  ko.applyBindings(viewModel);

  callback(target);
};

function DetailsCommentViewModel(comment_id) {
  var self = this;
  self.item = ko.observable();

  self.inputReply = ko.observable("");
  self.isShowDelete = ko.computed(function(val){
    if (self.item() != null){
      return CurrentUserID == self.item().comment.user_id();
    }else{
      return false;
    }
  });

  load_comment(comment_id);

  function load_comment(id){
    $.ajax({
      type: "GET",
      cache: false,
      url: "/api/comments/" + id,
      success: function (data) {
        console.log(data);
        self.item(ko.mapping.fromJS(data));
      }
    });
  }


  self.save_reply = function(){
    if (self.inputReply() == ""){
      return;
    }

    $.ajax({
      type: "POST",
      cache: false,
      url: "/comments/" + self.item().comment.id() + "/replies",
      data: { reply: { text: self.inputReply() }},
      success: function(data){
        self.inputReply("");
        self.item().replies.unshift(ko.mapping.fromJS(data));
      }
    });
  }

  self.delete_comment = function(){
    ons.notification.confirm({message: '本当に削除しますか?'}).then(function(result){
      if (result == 1){
        $.ajax({
          type: "DELETE",
          cache: false,
          url: "/comments/" + self.item().comment.id(),
          success: function(data){
            document.location = "/users/" + CurrentUserID + "/tunes";
          }
        });
      }
    });
  }

  self.date_format = function(date){
    return moment(date).format('YYYY/MM/DD HH:mm');
  }
}


