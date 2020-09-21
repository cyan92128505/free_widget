var native_view_web = {
  onClick: null,
  color: '#88b04b',

  dict: {},

  initialize: function (viewId, container, onLoaded, onError, onClick, onScan) {
    var $ = native_view_web;

    if (onClick) {
      $.onClick = onClick;
      container.addEventListener('click', function (event) {
        $.click_handler(event, viewId);
      }, false);
    }

    onLoaded();
  },

  click_handler: function (event, viewId) {
    var $ = native_view_web;
    $.onClick();
  },

  dispose: function (container, viewId) {
    var $ = native_view_web;
    $.dict['native-container-' + viewId] = false;
  },

  triggerBuild: function (viewId) {
    var $ = native_view_web;

    for (const view of document.getElementsByTagName('flt-platform-view')) {
      var item = view.shadowRoot.getElementById('native-container-' + viewId);
      if (item != null) {
        $.dict['native-container-' + viewId] = true;
        item.dispatchEvent(new Event('build'));
      }
    }
  },
};

window.dispatchEvent(new Event('native_view_web_ready'));