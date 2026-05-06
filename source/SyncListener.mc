import Toybox.Communications;
import Toybox.Application.Storage;

class SyncListener extends Communications.ConnectionListener {
    function initialize() {
        ConnectionListener.initialize();
    }

    function onComplete() as Void {
        Storage.deleteValue("offline_workout");
        Storage.setValue("sync_status", "SYNCED");
    }

    function onError() as Void {
        Storage.setValue("sync_status", "PENDING");
    }
}
