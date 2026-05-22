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

        dc.setColor(Graphics.COLOR_TRANSPARENT, 0x0E0E1F);
        dc.clear();

        // Título e Ícones Baseado na Modal da Screenshot 1 - Calculado dinamicamente
        var fontXTinyH = dc.getFontHeight(Graphics.FONT_XTINY);
        var fontTinyH = dc.getFontHeight(Graphics.FONT_TINY);
        var linePadding = 5;

        var titleY1 = h * 0.1;
        var titleY2 = titleY1 + fontXTinyH + linePadding;

        dc.setColor(0xFFFFFF as Graphics.ColorValue, Graphics.COLOR_TRANSPARENT);
        dc.drawText(centerX, titleY1, Graphics.FONT_XTINY, "Hoje, 14/06", Graphics.TEXT_JUSTIFY_CENTER);
        dc.drawText(centerX, titleY2, Graphics.FONT_SMALL, "Intervalados", Graphics.TEXT_JUSTIFY_CENTER);
        
        var detailsStartY = h * 0.38;
        var detailsY2 = detailsStartY + fontTinyH + linePadding;
        var detailsY3 = detailsY2 + fontTinyH + linePadding;

        dc.setColor(0x00D4FF as Graphics.ColorValue, Graphics.COLOR_TRANSPARENT);
        dc.drawText(centerX, detailsStartY, Graphics.FONT_TINY, "Aquecimento 2km", Graphics.TEXT_JUSTIFY_CENTER);
        dc.drawText(centerX, detailsY2, Graphics.FONT_TINY, "8x 400m (Pace 4:15)", Graphics.TEXT_JUSTIFY_CENTER);
        dc.drawText(centerX, detailsY3, Graphics.FONT_TINY, "Desaquecimento", Graphics.TEXT_JUSTIFY_CENTER);

        // Botão "Começar Treino" simulado visualmente - Formato Cápsula Oval (Largura controlada 65%)
        var btnW = w * 0.65;
        var btnH = 38;
        var btnX = (w - btnW) / 2;
        var btnY = h * 0.78;
        
        dc.setColor(0x00D4FF as Graphics.ColorValue, Graphics.COLOR_TRANSPARENT);
        dc.fillRoundedRectangle(btnX, btnY, btnW, btnH, btnH / 2);
        
        dc.setColor(0x0E0E1F as Graphics.ColorValue, Graphics.COLOR_TRANSPARENT);
        dc.drawText(centerX, btnY + (btnH / 2), Graphics.FONT_XTINY, "ENTER: Começar", Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);
    }
}
