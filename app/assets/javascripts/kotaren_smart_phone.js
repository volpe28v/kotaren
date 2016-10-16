ons.ready(function(){
  ons.disableAutoStyling();
  document.querySelector('ons-navigator').pushPage('tunes.html');
});

var viewModelFactory = {};
viewModelFactory['tunes.html'] = function() { return new TunesViewModel(); }
viewModelFactory['albums.html'] = function() { return new AlbumsViewModel(); }
viewModelFactory['tunings.html'] = function() { return new TuningsViewModel(); }
viewModelFactory['activity.html'] = function() { return new ActivityViewModel(); }

window.ons.NavigatorElement.rewritables.link = function(element, target, options, callback) {
  if (!options.viewModel) {
    options.viewModel = viewModelFactory[options.page]();
  }
  ko.applyBindings(options.viewModel, target);
  callback(target);
};

window.fn = {};
window.fn.open = function() {
  var menu = document.getElementById('menu');
  menu.open();
};

window.fn.load = function(page) {
  var menu = document.getElementById('menu');
  menu.close();
  document.querySelector('ons-navigator').resetToPage(page,{animation: "fade"});
};

var AllTunes = null;

function TunesViewModel(tunes) {
  var self = this;

  self.items = ko.observableArray([]);
  self.isTop = ko.observable(true);

  if (tunes == null){
    loadHeatMap();
    // 全曲リスト
    if (AllTunes == null){
      loadItems().then(function(tunes){
        sortItems();
        AllTunes = tunes;
      });
    }else{
      self.items = AllTunes;
      sortItems();
    }
  }else{
    // アルバムから遷移
    self.items(tunes);
    self.isTop(false);
    sortItems();
  }

  console.log(self.items());

  function loadItems(){
    return new Promise(function(callback){
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
          callback(self.items);
        }
      });
    });
  }

  function loadHeatMap(){
    $('#heatmap_tunes').empty();
    var disp_map_count = 7;
    if (window.innerWidth < 375){
      disp_map_count--;
    }

    var startDate = new Date();
    startDate.setMonth(startDate.getMonth() - (disp_map_count - 1));
    var parser = function(data) {
      return eval("(" + data + ")");
    };
    var cal = new CalHeatMap();
    cal.init({
      itemSelector: "#heatmap_tunes",
      data: "/api/activities?user_id=" + UserID + "&start={{d:start}}&stop={{d:end}}",
      afterLoadData: parser,
      cellSize: 7,
      domain: "month",
      subDomain: "day",
      subDomainDateFormat: "%m/%d %Y",
      range: disp_map_count,
      tooltip: true,
      start: startDate,
      domainLabelFormat: "%b",
      itemName: ["activity", "activities"],
      legend: [1,3,7,10],
      displayLegend: false
    });
  }

  function sortItems(){
    self.items.sort(function(l,r){
      var l_date = getValidDate(l.progress.updated_at);
      var r_date = getValidDate(r.progress.updated_at);
      return moment(l_date) < moment(r_date) ? 1 : -1;
    });
  }

  function getValidDate(date){
    if (date && date()){ return date(); }
    return new Date(-8640000000000000);
  }

  self.refresh = function(){
    loadItems().then(function(tunes){
      sortItems();
    });
    loadHeatMap();
  }

  self.detailsItem = function() {
    document.querySelector('ons-navigator').pushPage('details.html', {viewModel: new DetailsViewModel(this)});
  }

  self.date_format = function(date){
    if (date == null || date() == null){ return ""; }
    return moment(date()).format('YYYY/MM/DD');
  };
}

function DetailsViewModel(item) {
  var self = this;
  self.item = item;
  self.tunes = AllTunes;

  self.inputComment = ko.observable("");
  self.comments = ko.observableArray([]);

  if (self.item.progress.updated_at == null){
    self.item.progress.updated_at = ko.observable(null);
  }

  self.updated_date = ko.computed(function(){
    if (self.item.progress.updated_at() == null){ return null; }

    return moment(self.item.progress.updated_at()).format('YYYY/MM/DD HH:mm');
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
        var mapped_data = data.map(function(d){ return ko.mapping.fromJS(d); });
        self.comments(mapped_data);
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
    if (self.inputComment() == ""){
      return;
    }

    $.ajax({
      type: "POST",
      cache: false,
      url: "/users/" + UserID + "/tunes/" + self.item.tune.id() + "/comments",
      data: {"comment[text]": self.inputComment()},
      success: function (data) {
        self.inputComment("");
        self.comments.unshift(ko.mapping.fromJS(data));
      }
    });
  }

  self.detailsComment= function() {
    document.querySelector('ons-navigator').pushPage('detailsComment.html', {viewModel: new DetailsCommentViewModel(this, self.comments)});
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
      url: "/users/" + UserID + "/tunes/update_progress",
      data: {
        tune_id: self.item.tune.id,
        progress_val: valid_parcent
      },
      success: function (data) {
        self.item.progress.updated_at(data.date);
      }
    });
  }

  self.tunesListByTuning = function() {
    var tuning_id = self.item.tuning.id();
    var tunes = self.tunes().filter(function(tune){
      return tune.tune.tuning_id() == tuning_id;
    });
    document.querySelector('ons-navigator').pushPage('tunes.html', {viewModel: new TunesViewModel(tunes)});
  }
}

function DetailsCommentViewModel(comment, comments) {
  var self = this;
  self.item = comment;
  self.comments = comments;

  self.inputReply = ko.observable("");
  self.isShowDelete = CurrentUserID == self.item.comment.user_id();

  self.save_reply = function(){
    if (self.inputReply() == ""){
      return;
    }

    $.ajax({
      type: "POST",
      cache: false,
      url: "/comments/" + self.item.comment.id() + "/replies",
      data: { reply: { text: self.inputReply() }},
      success: function(data){
        self.inputReply("");
        self.item.replies.unshift(ko.mapping.fromJS(data));
      }
    });
  }

  self.delete_comment = function(){
    ons.notification.confirm({message: '本当に削除しますか?'}).then(function(result){
      if (result == 1){
        $.ajax({
          type: "DELETE",
          cache: false,
          url: "/comments/" + self.item.comment.id(),
          success: function(data){
            self.comments.remove(self.item);
            document.querySelector('ons-navigator').popPage();
          }
        });
      }
    });
  }

  self.date_format = function(date){
    return moment(date).format('YYYY/MM/DD HH:mm');
  }
}

function AlbumsViewModel() {
  var self = this;

  self.items = ko.observableArray([]);
  self.tunes = AllTunes;
  loadItems();

  function loadItems(){
    self.tunes().forEach(function(tune){
      tune.albums().forEach(function(album){
        if (self.items().filter(function(elem){ return elem.id() == album.id() }).length == 0){
          self.items.push(album);
        }
      });
    });
    sortItems();
  }

  function sortItems(){
    self.items.sort(function(l,r){
      return l.id() < r.id() ? 1 : -1;
    });
  }

  self.tunesList = function() {
    var album_id = this.id();
    var tunes = self.tunes().filter(function(tune){
      return tune.albums().filter(function(album){
        return album.id() == album_id;
      }).length > 0;
    });
    document.querySelector('ons-navigator').pushPage('tunes.html', {viewModel: new TunesViewModel(tunes)});
  }
}

function TuningsViewModel() {
  var self = this;

  self.items = ko.observableArray([]);
  self.tunes = AllTunes;
  loadItems();

  function loadItems(){
    self.tunes().forEach(function(tune){
      if (self.items().filter(function(elem){ return elem.tuning.id() == tune.tuning.id(); }).length == 0){
        var same_tunes = self.tunes().filter(function(t){ return t.tuning.id() == tune.tuning.id(); });
        self.items.push({tuning: tune.tuning, count: same_tunes.length, tune_name: same_tunes[0].tune.title() });
      }
    });
    sortItems();
  }

  function sortItems(){
    self.items.sort(function(l,r){
      if (l.tuning.name() == r.tuning.name()){
        return l.tuning.capo() > r.tuning.capo() ? 1 : -1;
      }else if (l.tuning.name() < r.tuning.name()){
        return -1;
      }else{
        return 1;
      }
    });
  }

  self.tunesList = function() {
    var tuning_id = this.tuning.id();
    var tunes = self.tunes().filter(function(tune){
      return tune.tune.tuning_id() == tuning_id;
    });
    document.querySelector('ons-navigator').pushPage('tunes.html', {viewModel: new TunesViewModel(tunes)});
  }
}

function ActivityViewModel() {
  var self = this;

  self.comments = ko.observableArray([]);

  load_comments();

  function load_comments(){
    $.ajax({
      type: "GET",
      cache: false,
      url: "/api/comments",
      success: function (data) {
        console.log(data);
        var mapped_data = data.map(function(d){ return ko.mapping.fromJS(d); });
        self.comments(mapped_data);
      }
    });
  }

  self.date_format = function(date){
    return moment(date).format('YYYY/MM/DD');
  }

  self.detailsComment = function() {
    document.querySelector('ons-navigator').pushPage('detailsComment.html', {viewModel: new DetailsCommentViewModel(this, self.comments)});
  }
}

