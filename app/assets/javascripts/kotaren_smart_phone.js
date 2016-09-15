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
  console.log(item);
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
