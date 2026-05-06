import Toybox.WatchUi;

class WorkoutDetailsDelegate extends WatchUi.BehaviorDelegate {
    function initialize() {
        BehaviorDelegate.initialize();
    }

    function onKey(keyEvent) {
        if (keyEvent.getKey() == WatchUi.KEY_ENTER) {
            var app = getApp();
            app.toggleRecording(); // Inicia a sessão ActivityRecording
            WatchUi.pushView(new RuneasyView("Intervalados 8x400m", "4:15"), new RunEasyDelegate(), WatchUi.SLIDE_LEFT);
            return true;
        }
        return false;
    }
}
