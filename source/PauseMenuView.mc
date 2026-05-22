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

        dc.setColor(Graphics.COLOR_TRANSPARENT, 0x0E0E1F);
        dc.clear();

        dc.setColor(0x00D4FF as Graphics.ColorValue, Graphics.COLOR_TRANSPARENT);
        dc.drawText(centerX, h * 0.15, Graphics.FONT_SMALL, "Treino Pausado", Graphics.TEXT_JUSTIFY_CENTER);

        var options = ["Retomar", "Salvar Treino", "Descartar"];
        var btnW = (w * 0.65).toNumber();
        var btnH = 36;
        var startY = h * 0.35;
        var spacing = btnH + 8; // Espaçamento dinâmico baseado na altura do botão + padding

        for (var i = 0; i < options.size(); i++) {
            var y = startY + (i * spacing);
            var isSelected = (i == selectedIndex);

            if (isSelected) {
                dc.setColor(0x00D4FF as Graphics.ColorValue, Graphics.COLOR_TRANSPARENT);
                dc.fillRoundedRectangle(centerX - (btnW/2), y, btnW, btnH, btnH / 2);
                dc.setColor(0x0E0E1F as Graphics.ColorValue, Graphics.COLOR_TRANSPARENT);
            } else {
                dc.setColor(0x1E1E38 as Graphics.ColorValue, Graphics.COLOR_TRANSPARENT);
                dc.fillRoundedRectangle(centerX - (btnW/2), y, btnW, btnH, btnH / 2);
                dc.setPenWidth(1);
                dc.setColor(0x2E2E5C as Graphics.ColorValue, Graphics.COLOR_TRANSPARENT);
                dc.drawRoundedRectangle(centerX - (btnW/2), y, btnW, btnH, btnH / 2);
                dc.setColor(0xFFFFFF as Graphics.ColorValue, Graphics.COLOR_TRANSPARENT);
            }

            dc.drawText(centerX, y + (btnH/2), Graphics.FONT_TINY, options[i], Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);
        }
    }
}
