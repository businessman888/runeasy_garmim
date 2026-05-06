import Toybox.Graphics;
import Toybox.WatchUi;

class WorkoutDetailsView extends WatchUi.View {
    function initialize() {
        View.initialize();
    }

    function onLayout(dc) {
    }

    function onUpdate(dc) {
        var w = dc.getWidth();
        var h = dc.getHeight();
        var centerX = w / 2;

        dc.setColor(Graphics.COLOR_TRANSPARENT, 0x131F54 as Graphics.ColorValue);
        dc.clear();

        // Título e Ícones Baseado na Modal da Screenshot 1
        dc.setColor(0xFFFFFF as Graphics.ColorValue, Graphics.COLOR_TRANSPARENT);
        dc.drawText(centerX, h * 0.1, Graphics.FONT_XTINY, "Hoje, 14/06", Graphics.TEXT_JUSTIFY_CENTER);
        
        dc.drawText(centerX, h * 0.22, Graphics.FONT_SMALL, "Intervalados", Graphics.TEXT_JUSTIFY_CENTER);
        
        dc.setColor(0x00D4FF as Graphics.ColorValue, Graphics.COLOR_TRANSPARENT);
        dc.drawText(centerX, h * 0.38, Graphics.FONT_TINY, "Aquecimento 2km", Graphics.TEXT_JUSTIFY_CENTER);
        dc.drawText(centerX, h * 0.50, Graphics.FONT_TINY, "8x 400m (Pace 4:15)", Graphics.TEXT_JUSTIFY_CENTER);
        dc.drawText(centerX, h * 0.62, Graphics.FONT_TINY, "Desaquecimento", Graphics.TEXT_JUSTIFY_CENTER);

        // Botão "Começar Treino" simulado visualmente (Screenshot 1)
        var btnW = w * 0.8;
        var btnH = 40;
        var btnX = (w - btnW) / 2;
        var btnY = h * 0.78;
        
        dc.setColor(0x00D4FF as Graphics.ColorValue, Graphics.COLOR_TRANSPARENT);
        dc.fillRoundedRectangle(btnX, btnY, btnW, btnH, 12);
        
        dc.setColor(0x131F54 as Graphics.ColorValue, Graphics.COLOR_TRANSPARENT);
        dc.drawText(centerX, btnY + (btnH / 2), Graphics.FONT_XTINY, "ENTER: Começar", Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);
    }
}
