import Toybox.WatchUi;
import Toybox.Application.Storage;

class PauseMenuDelegate extends WatchUi.BehaviorDelegate {
    private var mView;

    function initialize(view) {
        BehaviorDelegate.initialize();
        mView = view;
    }

    function onPreviousPage() {
        mView.selectedIndex = (mView.selectedIndex - 1);
        if (mView.selectedIndex < 0) { mView.selectedIndex = 2; }
        WatchUi.requestUpdate();
        return true;
    }

    function onNextPage() {
        mView.selectedIndex = (mView.selectedIndex + 1) % 3;
        WatchUi.requestUpdate();
        return true;
    }

    function onKey(keyEvent) {
        if (keyEvent.getKey() == WatchUi.KEY_ENTER) {
            var app = getApp();
            
            if (mView.selectedIndex == 0) {
                // Retomar
                app.toggleRecording(); // Retoma a sessão
                WatchUi.popView(WatchUi.SLIDE_RIGHT);
            } else if (mView.selectedIndex == 1) {
                // Salvar Treino
                var info = Toybox.Activity.getActivityInfo();
                var workoutData = {};
                
                if (info != null) {
                    var avgSpeed = info.averageSpeed;
                    var avgPace = 0;
                    if (avgSpeed != null && avgSpeed > 0) {
                        avgPace = 1000.0 / (avgSpeed * 60.0); // pace em minutos por km
                    }
                    
                    workoutData = {
                        "workoutId" => Toybox.Time.now().value(),
                        "averagePace" => avgPace,
                        "totalDistance" => (info.elapsedDistance != null) ? info.elapsedDistance : 0,
                        "averageHR" => (info.averageHeartRate != null) ? info.averageHeartRate : 0,
                        "totalTime" => (info.timerTime != null) ? info.timerTime : 0
                    };
                } else {
                    workoutData = {
                        "workoutId" => Toybox.Time.now().value(),
                        "averagePace" => 0,
                        "totalDistance" => 0,
                        "averageHR" => 0,
                        "totalTime" => 0
                    };
                }

                // 1. Salvar no arquivo FIT fisicamente (Segurança)
                app.saveSession();
                
                // 2. Tentar Enviar ou Adicionar à Fila (Deferred Sync)
                app.sendWorkoutToPhone(workoutData);

                Storage.setValue("workout_completed", true);
                WatchUi.popView(WatchUi.SLIDE_IMMEDIATE); // Remove PauseMenu
                WatchUi.popView(WatchUi.SLIDE_IMMEDIATE); // Remove RuneasyView
                WatchUi.popView(WatchUi.SLIDE_RIGHT); // Volta para Home
            } else if (mView.selectedIndex == 2) {
                // Descartar
                app.discardSession();
                WatchUi.popView(WatchUi.SLIDE_IMMEDIATE); // Remove PauseMenu
                WatchUi.popView(WatchUi.SLIDE_IMMEDIATE); // Remove RuneasyView
                WatchUi.popView(WatchUi.SLIDE_RIGHT); // Volta para Home
            }
            return true;
        }
        return false;
    }
}
