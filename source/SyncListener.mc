import Toybox.Communications;
import Toybox.Application.Storage;
import Toybox.WatchUi;

class SyncListener extends Communications.ConnectionListener {
    function initialize() {
        ConnectionListener.initialize();
    }

    function onComplete() as Void {
        Storage.deleteValue("offline_workout");
        Storage.setValue("sync_status", "SYNCED");
        WatchUi.requestUpdate();
    }

    function onError() as Void {
        Storage.setValue("sync_status", "PENDING");
        WatchUi.requestUpdate();
    }
}
