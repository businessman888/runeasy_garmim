import Toybox.WatchUi;
import Toybox.System;

class RunEasyDelegate extends WatchUi.BehaviorDelegate {

    function initialize() {
        BehaviorDelegate.initialize();
    }

    function onKey(keyEvent) {
        if (keyEvent.getKey() == WatchUi.KEY_ENTER) {
            var app = getApp();
            app.toggleRecording(); 
            
            var pauseView = new PauseMenuView();
            WatchUi.pushView(pauseView, new PauseMenuDelegate(pauseView), WatchUi.SLIDE_LEFT);
            return true;
        }
        return false;
    }
}
