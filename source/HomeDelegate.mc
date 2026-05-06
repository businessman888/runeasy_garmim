import Toybox.WatchUi;

class HomeDelegate extends WatchUi.BehaviorDelegate {
    function initialize() {
        BehaviorDelegate.initialize();
    }

    function onKey(keyEvent) {
        if (keyEvent.getKey() == WatchUi.KEY_ENTER) {
            WatchUi.pushView(new WorkoutDetailsView(), new WorkoutDetailsDelegate(), WatchUi.SLIDE_LEFT);
            return true;
        }
        return false;
    }
}
