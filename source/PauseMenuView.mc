import Toybox.Graphics;
import Toybox.WatchUi;

class PauseMenuView extends WatchUi.View {
    public var selectedIndex = 0; // 0: Retomar, 1: Salvar, 2: Descartar
    
    function initialize() {
        View.initialize();
    }

    function onUpdate(dc) {
        var w = dc.getWidth();
        var h = dc.getHeight();
        var centerX = w / 2;

        dc.setColor(Graphics.COLOR_TRANSPARENT, 0x131F54 as Graphics.ColorValue);
        dc.clear();

        dc.setColor(0x00D4FF as Graphics.ColorValue, Graphics.COLOR_TRANSPARENT);
        dc.drawText(centerX, h * 0.15, Graphics.FONT_SMALL, "Treino Pausado", Graphics.TEXT_JUSTIFY_CENTER);

        var options = ["Retomar", "Salvar Treino", "Descartar"];
        var btnW = 160;
        var btnH = 40;
        var startY = h * 0.35;
        var spacing = 50;

        for (var i = 0; i < options.size(); i++) {
            var y = startY + (i * spacing);
            var isSelected = (i == selectedIndex);

            if (isSelected) {
                dc.setColor(0x00D4FF as Graphics.ColorValue, Graphics.COLOR_TRANSPARENT);
                dc.fillRoundedRectangle(centerX - (btnW/2), y, btnW, btnH, 12);
                dc.setColor(0x131F54 as Graphics.ColorValue, Graphics.COLOR_TRANSPARENT);
            } else {
                dc.setColor(0x1A2859 as Graphics.ColorValue, Graphics.COLOR_TRANSPARENT);
                dc.fillRoundedRectangle(centerX - (btnW/2), y, btnW, btnH, 12);
                dc.setPenWidth(1);
                dc.setColor(0x3A508C as Graphics.ColorValue, Graphics.COLOR_TRANSPARENT);
                dc.drawRoundedRectangle(centerX - (btnW/2), y, btnW, btnH, 12);
                dc.setColor(0xFFFFFF as Graphics.ColorValue, Graphics.COLOR_TRANSPARENT);
            }

            dc.drawText(centerX, y + (btnH/2), Graphics.FONT_TINY, options[i], Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);
        }
    }
}
