import Toybox.WatchUi;

class HomeDelegate extends WatchUi.BehaviorDelegate {
    function initialize() {
        BehaviorDelegate.initialize();
    }

    function onKey(keyEvent) {
        if (keyEvent.getKey() == WatchUi.KEY_ENTER) {
            var workoutCompleted = Toybox.Application.Storage.getValue("workout_completed");
            if (workoutCompleted != null && workoutCompleted) {
                Toybox.System.exit();
                return true;
            }
            WatchUi.pushView(new WorkoutDetailsView(), new WorkoutDetailsDelegate(), WatchUi.SLIDE_LEFT);
            return true;
        }
        return false;
    }
}
