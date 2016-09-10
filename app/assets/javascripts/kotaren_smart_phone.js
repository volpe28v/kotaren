  // Rewrite Navigator behavior to connect the new page with the viewModel
console.log(window);
  window.OnsNavigatorElement.rewritables.link = function(element, target, options, callback) {
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
  }

  // List page view model
  function ListViewModel() {
    var self = this;

    self.items = ko.observableArray([]);
    for(var i = 0; i < 10; i++) {
      self.items.push(new ListItem("Item " + i));
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
