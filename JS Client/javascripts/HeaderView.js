// Generated by CoffeeScript 1.6.3
(function() {
  var _ref,
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  this.HeaderView = (function(_super) {
    __extends(HeaderView, _super);

    function HeaderView() {
      _ref = HeaderView.__super__.constructor.apply(this, arguments);
      return _ref;
    }

    HeaderView.prototype.tagName = "nav";

    HeaderView.prototype.events = {
      "change #remotes": "onRemoteChanged"
    };

    HeaderView.prototype.initialize = function() {
      var _this = this;
      this.$el.append('<select id="remotes"><option value="oi">-- no applications detected yet --</option></select>');
      return this.model.remotes.on("add", function(remote) {
        _this.$el.find('select#remotes').append('<option value="' + remote.cid + '">' + remote.get('binaryName') + ' @ ' + remote.get('computerName') + '</option>');
        return _this.$el.find('select#remotes option:first').text('-- ' + _this.model.remotes.length + ' application(s) detected --');
      });
    };

    HeaderView.prototype.onRemoteChanged = function(event) {
      var remote;
      if (remote = this.model.remotes.get(this.$el.find('select#remotes').val())) {
        return this.trigger("remoteChanged", remote);
      }
    };

    return HeaderView;

  })(Backbone.View);

}).call(this);