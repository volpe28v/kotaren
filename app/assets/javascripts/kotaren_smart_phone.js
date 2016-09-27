ons.ready(function(){
  document.querySelector('ons-navigator').pushPage('list.html');
});

window.ons.NavigatorElement.rewritables.link = function(element, target, options, callback) {
  if (!options.viewModel) {
    options.viewModel = new ListViewModel();
  }
  ko.applyBindings(options.viewModel, target);
  callback(target);
};

// Item model
function ListItem(content) {
  var self = this;
  self.content = content;
}


// Details page view model
function DetailsViewModel(item) {
  var self = this;
  self.item = item;

  self.inputComment = ko.observable("");
  self.comments = ko.observableArray([]);

  if (self.item.progress.updated_at == null){
    self.item.progress.updated_at = ko.observable(null);
  }

  self.updated_date = ko.computed(function(){
    if (self.item.progress.updated_at() == null){ return null; }

    return moment(self.item.progress.updated_at()).format('YYYY/MM/DD');
  });

  load_comments();

  function load_comments(){
    $.ajax({
      type: "GET",
      cache: false,
      url: "/api/comments",
      data: {
        user_id: UserID,
        tune_id: item.tune.id
      },
      success: function (data) {
        console.log(data);
        self.comments(data);
      }
    });
  }

  self.date_format = function(date){
    return moment(date).format('YYYY/MM/DD HH:mm');
  }

  self.do_plus = function(){
    var after_percent = self.item.progress.percent() + 1;

    update_progress(after_percent);
  }

  self.do_plus10 = function(){
    var after_percent = self.item.progress.percent() + 10;

    update_progress(after_percent);
  }

  self.do_minus10 = function(){
    var after_percent = self.item.progress.percent() - 10;

    update_progress(after_percent);
  }

  self.save_comment = function(){
    var comment = self.inputComment();
    console.log(comment);
    self.inputComment("");

    $.ajax({
      type: "POST",
      cache: false,
      url: "/users/" + UserID + "/tunes/" + self.item.tune.id() + "/comments",
      data: {"comment[text]": comment },
      success: function (data) {
        self.comments.unshift(data);
      }
    });
  }

  function update_progress(percent){
    var valid_parcent = percent;
    if (percent > 100){
      valid_parcent = 100;
    }else if (percent < 0){
      valid_parcent = 0;
    }

    self.item.progress.percent(valid_parcent);

    $.ajax({
      type: "POST",
      cache: false,
      url: "/api/progresses",
      data: {
        user_id: UserID,
        tune_id: self.item.tune.id,
        progress_val: valid_parcent
      },
      success: function (data) {
        console.log(data);
        self.item.progress.updated_at(data.date);
      }
    });
  }
}

// List page view model
function ListViewModel() {
  var self = this;

  self.items = ko.observableArray([]);
  loadItems();

  function loadItems(){
    self.items([]);
    $.ajax({
      type: "GET",
      cache: false,
      url: "/api/tunes",
      data: { user_id: UserID },
      success: function (data) {
        console.log(data);
        var mapped_data = data.map(function(d){ return ko.mapping.fromJS(d); });
        self.items(mapped_data);
        sortItems();
      }
    });
  }

  function sortItems(){
    self.items.sort(function(l,r){
      var l_date = l.progress.updated_at ? l.progress.updated_at() : new Date(-8640000000000000);
      var r_date = r.progress.updated_at ? r.progress.updated_at() : new Date(-8640000000000000);
      return moment(l_date) < moment(r_date) ? 1 : -1;
    });
  }

  self.refresh = function(){
    loadItems();
  }

  self.nextCarouselItem = function(index) {
    document.querySelectorAll('ons-carousel')[index()].next();
  }

  self.addItem = function() {
    self.items.push(new ListItem('Item ' + self.items().length));
  };

  self.removeItem = function() {
    self.items.remove(this);
  }

  self.detailsItem = function() {
    document.querySelector('ons-navigator').pushPage('details.html', {viewModel: new DetailsViewModel(this)});
  }
}
