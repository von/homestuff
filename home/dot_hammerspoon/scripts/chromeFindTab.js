// Find a Chrome tab with given name and focus on it
// Arguments:
//  <string>  String to search for in tab title
//  <string>  Window Id of window containing tab (optional)
// Outputs to stderr:
//  <winId>   Window Id of window containing found tab (for caching)
//
// This uses JXA: https://github.com/JXA-Cookbook/JXA-Cookbook
// Kudos: https://liuhao.im/english/2017/06/02/macos-automation-and-shortcuts-with-hammerspoon.html
// Kudos: https://stackoverflow.com/a/41645893/197789

ObjC.import('stdlib')

function run(argv) {
  var searchString = argv[0]
  var cachedWindowId = Number(argv[1])  // Optional, may be NaN

  // Annoyingly we need to use two interfaces to windows. One to access tabs and
  // the other to raise the window. Getting the two list of windows now, before
  // we start messing with them, seems to result in lists with windows in the same
  // order. Otherwise there seems to be no way to correlate them.
  var chromeApp = Application('Google Chrome');
  var cwins = chromeApp.windows();

  var system = Application('System Events');
  // Filter windows without titles
  var swins = system.processes['Google Chrome'].windows().filter(function hasTitle(w) {return w.title()});

  // loop tabs to find a web page with a title of <name>
  for (var i = 0; i < cwins.length; i++) {
    var cwin = cwins[i];
    var swin = swins[i];

    // If we have a cached window, only check it
    // TODO; If the cached window doesn't work, try without it
    if (cachedWindowId) {
      if (cachedWindowId != cwin.id()) {
        continue;
      }
    }
    var tabs = cwin.tabs;
    for (var j = 0; j < tabs.length; j++) {
      var tab = tabs.at(j);
      if (tab.title().indexOf(searchString) > -1) {

        // Now raise the window.
        // Catch if we don't have permission. See:
        // https://apple.stackexchange.com/a/291594/104604
        try {
          swin.actions['AXRaise'].perform();
        } catch(err) {
          // console.log() outputs to stderr
          console.log("Error raising window: %s", err.message);
          $.exit(1)
        }

        // Print window Id to stderr so we can cache it
        var id = cwin.id()
        console.log(cwin.id());

        // Now activate tab we found.
        // Do this after raising window as it perturbs swin object and will
        // cause a "Can't get object." error.
        cwin.activeTabIndex = j + 1;

        // Wait to activate until window we want is on top to
        // spare visual churn.
        chromeApp.activate();
        $.exit(0)
      }
    }
  }
  // Failed to find tab
  $.exit(2)
}
