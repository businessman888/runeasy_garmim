import Toybox.Application;
import Toybox.Application.Storage;
import Toybox.Communications;
import Toybox.Lang;
import Toybox.WatchUi;
import Toybox.ActivityRecording;
import Toybox.Activity;
import Toybox.System;
import Toybox.Position;
import Toybox.Sensor;

var gSession = null;

class RuneasyApp extends Application.AppBase {

    function initialize() {
        AppBase.initialize();
    }

    function onStart(state as Dictionary?) as Void {
        Position.enableLocationEvents(Position.LOCATION_CONTINUOUS, method(:onPosition));
        Sensor.setEnabledSensors([Sensor.SENSOR_HEARTRATE]);
        Sensor.enableSensorEvents(method(:onSensor));
        
        if (Toybox has :Communications) {
            var phoneMethod = method(:onPhoneMessage) as Method(msg as Communications.PhoneAppMessage) as Void;
            Communications.registerForPhoneAppMessages(phoneMethod);
        }

        checkPendingSync();
    }

    function onPhoneMessage(msg as Communications.PhoneAppMessage) as Void {
        // Manipulador para confirmações vindas do celular
        var data = msg.data;
        if (data != null) {
            // Lógica futura para processar dados vindos da IA
        }
    }

    function sendWorkoutToPhone(workoutData as Dictionary) as Void {
        var deviceSettings = System.getDeviceSettings();
        if (deviceSettings.phoneConnected) {
            Storage.setValue("sync_status", "SYNCING");
            Communications.transmit(workoutData, null, new SyncListener());
        } else {
            Storage.setValue("offline_workout", workoutData);
            Storage.setValue("sync_status", "PENDING");
        }
    }

    function checkPendingSync() as Void {
        var pendingData = Storage.getValue("offline_workout");
        var deviceSettings = System.getDeviceSettings();
        
        if (pendingData != null && deviceSettings.phoneConnected) {
            Storage.setValue("sync_status", "SYNCING");
            Communications.transmit(pendingData, null, new SyncListener());
        }
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
                    :sport=>Activity.SPORT_GENERIC
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

    function onStop(state as Dictionary?) as Void {
        if (gSession != null && gSession.isRecording()) {
            gSession.stop();
            gSession.save();
        }
        Position.enableLocationEvents(Position.LOCATION_DISABLE, method(:onPosition));
        Sensor.setEnabledSensors([]);
    }

    function getInitialView() as [Views] or [Views, InputDelegates] {
        return [ new HomeView(), new HomeDelegate() ];
    }
}

function getApp() as RuneasyApp {
    return Application.getApp() as RuneasyApp;
}