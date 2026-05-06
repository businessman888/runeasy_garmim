import Toybox.Graphics;
import Toybox.WatchUi;

class HomeView extends WatchUi.View {
    function initialize() {
        View.initialize();
    }

    function onShow() {
        var app = Application.getApp();
        if (app has :checkPendingSync) {
            app.checkPendingSync();
        }
    }

    function onLayout(dc) {
    }

    function onUpdate(dc) {
        var w = dc.getWidth();
        var h = dc.getHeight();
        var centerX = w / 2;

        // Fundo Premium Dark
        dc.setColor(Graphics.COLOR_TRANSPARENT, 0x131F54 as Graphics.ColorValue);
        dc.clear();

        // Título Superior
        dc.setColor(0xFFFFFF as Graphics.ColorValue, Graphics.COLOR_TRANSPARENT);
        dc.drawText(centerX, h * 0.12, Graphics.FONT_XTINY, "Treinos do dia", Graphics.TEXT_JUSTIFY_CENTER);

        // Glass Card for Workout of the Day (Estilo Screenshot 3 e 4)
        var cardW = w * 0.8;
        var cardH = h * 0.45;
        var cardX = (w - cardW) / 2;
        var cardY = h * 0.25;

        // Fundo do Card
        dc.setColor(0x1A2859 as Graphics.ColorValue, Graphics.COLOR_TRANSPARENT);
        dc.fillRoundedRectangle(cardX, cardY, cardW, cardH, 16);
        dc.setPenWidth(2);
        dc.setColor(0x00D4FF as Graphics.ColorValue, Graphics.COLOR_TRANSPARENT);
        dc.drawRoundedRectangle(cardX, cardY, cardW, cardH, 16);

        // Conteúdo do Card
        dc.setColor(0x00D4FF as Graphics.ColorValue, Graphics.COLOR_TRANSPARENT);
        dc.drawText(centerX, cardY + 10, Graphics.FONT_XTINY, "ALTA INTENSIDADE", Graphics.TEXT_JUSTIFY_CENTER);
        
        dc.setColor(0xFFFFFF as Graphics.ColorValue, Graphics.COLOR_TRANSPARENT);
        dc.drawText(centerX, cardY + 40, Graphics.FONT_TINY, "Intervalados", Graphics.TEXT_JUSTIFY_CENTER);
        dc.drawText(centerX, cardY + 65, Graphics.FONT_SMALL, "8x400m", Graphics.TEXT_JUSTIFY_CENTER);

        // Botão de Ação / Dica
        dc.setColor(0xFFFFFF as Graphics.ColorValue, Graphics.COLOR_TRANSPARENT);
        dc.drawText(centerX, h * 0.8, Graphics.FONT_XTINY, "ENTER: Ver Detalhes", Graphics.TEXT_JUSTIFY_CENTER);

        // Feedback de Status: Ícone de Nuvem / Pendente (Deferred Sync)
        var syncStatus = Toybox.Application.Storage.getValue("sync_status");
        if (syncStatus != null && syncStatus.equals("PENDING")) {
            // Desenha um ponto laranja discreto como alerta no topo direito
            dc.setColor(0xFF8C00 as Graphics.ColorValue, Graphics.COLOR_TRANSPARENT); 
            dc.fillCircle(w - 30, h * 0.15, 6);
            dc.setColor(0xFFFFFF as Graphics.ColorValue, Graphics.COLOR_TRANSPARENT);
            dc.drawText(w - 30, h * 0.15, Graphics.FONT_XTINY, "!", Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);
        }
    }
}
