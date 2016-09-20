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
  self.item = ko.mapping.fromJS(item);
  console.log(item);

  self.updated_date = ko.computed(function(){
    return moment(self.item.progress.updated_at).format('YYYY/MM/DD');
  });

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


  function update_progress(percent){
    if (percent > 100){
      self.item.progress.percent(100);
    }else if (percent < 0){
      self.item.progress.percent(0);
    }else{
      self.item.progress.percent(percent);
    }
  }
}

// List page view model
function ListViewModel() {
  var self = this;

  self.items = ko.observableArray([]);
  $.ajax({
    type: "GET",
    cache: false,
    url: "/api/tunes",
    success: function (data) {
      console.log(data);
      self.items(data);
    }
  });

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
