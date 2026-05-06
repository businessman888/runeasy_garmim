import Toybox.Application;
import Toybox.Lang;
import Toybox.WatchUi;
import Toybox.ActivityRecording;
import Toybox.Position;
import Toybox.Sensor;

var gSession = null;

class RuneasyApp extends Application.AppBase {

    function initialize() {
        AppBase.initialize();
    }

    // onStart() is called on application start up
    function onStart(state as Dictionary?) as Void {
        Position.enableLocationEvents(Position.LOCATION_CONTINUOUS, method(:onPosition));
        Sensor.setEnabledSensors([Sensor.SENSOR_HEARTRATE]);
        Sensor.enableSensorEvents(method(:onSensor));
    }

    function onPosition(info as Position.Info) as Void {
    }

    function onSensor(sensorInfo as Sensor.Info) as Void {
    }

    function toggleRecording() as Void {
        if (Toybox has :ActivityRecording) {
            if (gSession == null) {
                gSession = ActivityRecording.createSession({
                    :name=>"Run",
                    :sport=>ActivityRecording.SPORT_RUNNING
                });
            }
            if (gSession.isRecording()) {
                gSession.stop();
            } else {
                gSession.start();
            }
        }
    }

    function saveSession() as Void {
        if (gSession != null && gSession.isRecording() == false) {
            gSession.save();
            gSession = null;
        }
    }

    function discardSession() as Void {
        if (gSession != null && gSession.isRecording() == false) {
            gSession.discard();
            gSession = null;
        }
    }

    // onStop() is called when your application is exiting
    function onStop(state as Dictionary?) as Void {
        if (gSession != null && gSession.isRecording()) {
            gSession.stop();
            gSession.save();
        }
        Position.enableLocationEvents(Position.LOCATION_DISABLE, method(:onPosition));
        Sensor.setEnabledSensors([]);
    }

    //! Return the initial view of your application here
    function getInitialView() as [Views] or [Views, InputDelegates] {
        return [ new HomeView(), new HomeDelegate() ];
    }
}

function getApp() as RuneasyApp {
    return Application.getApp() as RuneasyApp;
}