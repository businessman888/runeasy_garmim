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
                app.saveSession();
                Storage.setValue("last_workout_insight", "+2% EFICIENCIA");
                WatchUi.switchToView(new FeedbackView(), new FeedbackDelegate(), WatchUi.SLIDE_LEFT);
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
