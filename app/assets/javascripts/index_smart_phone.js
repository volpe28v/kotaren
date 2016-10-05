ons.ready(function(){
  ko.applyBindings(new IndexViewModel());
});

function IndexViewModel(){
  var self = this;

  self.sign_up = function(){
    document.location = "users/sign_up";
  }

  self.sign_in = function(){
    document.location = "users/sign_in";
  }

  self.fb_sign_in = function(){
    document.location = "users/auth/facebook";
  }
}

