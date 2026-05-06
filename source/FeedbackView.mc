import Toybox.Graphics;
import Toybox.WatchUi;

class FeedbackView extends WatchUi.View {
    function initialize() {
        View.initialize();
    }

    function onLayout(dc) {
    }

    private function drawGlassCard(dc, x, y, width, height, value, unit) {
        var glassFillColor = 0x20326A as Graphics.ColorValue; 
        var glassBorderColor = 0x3A508C as Graphics.ColorValue; 
        
        dc.setColor(glassFillColor, Graphics.COLOR_TRANSPARENT);
        dc.fillRoundedRectangle(x, y, width, height, 12);
        dc.setPenWidth(1);
        dc.setColor(glassBorderColor, Graphics.COLOR_TRANSPARENT);
        dc.drawRoundedRectangle(x, y, width, height, 12);

        var font = Graphics.FONT_MEDIUM;
        var textWidth = dc.getTextWidthInPixels(value, font);
        var unitFont = Graphics.FONT_TINY;
        var unitWidth = dc.getTextWidthInPixels(unit, unitFont);
        
        var innerPadding = 6;
        var contentW = textWidth + innerPadding + unitWidth;
        var contentStartX = x + (width - contentW) / 2;

        dc.setColor(0xFFFFFF as Graphics.ColorValue, Graphics.COLOR_TRANSPARENT);
        dc.drawText(contentStartX, y + (height / 2), font, value, Graphics.TEXT_JUSTIFY_LEFT | Graphics.TEXT_JUSTIFY_VCENTER);
        
        dc.setColor(0x00FF00 as Graphics.ColorValue, Graphics.COLOR_TRANSPARENT);
        dc.drawText(contentStartX + textWidth + innerPadding, y + (height / 2), unitFont, unit, Graphics.TEXT_JUSTIFY_LEFT | Graphics.TEXT_JUSTIFY_VCENTER);
    }

    function onUpdate(dc) {
        var w = dc.getWidth();
        var h = dc.getHeight();
        var centerX = w / 2;

        dc.setColor(Graphics.COLOR_TRANSPARENT, 0x131F54 as Graphics.ColorValue);
        dc.clear();

        dc.setColor(0xFFFFFF as Graphics.ColorValue, Graphics.COLOR_TRANSPARENT);
        dc.drawText(centerX, h * 0.15, Graphics.FONT_SMALL, "Treino Completo", Graphics.TEXT_JUSTIFY_CENTER);
        
        dc.setColor(0x00D4FF as Graphics.ColorValue, Graphics.COLOR_TRANSPARENT);
        dc.drawText(centerX, h * 0.35, Graphics.FONT_LARGE, "Salvo com sucesso", Graphics.TEXT_JUSTIFY_CENTER);

        // Glass Card para Insight
        var cardW = 200;
        var cardH = 40;
        var cardX = centerX - (cardW / 2);
        var cardY = h * 0.6;
        
        drawGlassCard(dc, cardX, cardY, cardW, cardH, "Insight:", "+2% Eficiência");

        dc.setColor(0xFFFFFF as Graphics.ColorValue, Graphics.COLOR_TRANSPARENT);
        dc.drawText(centerX, h * 0.85, Graphics.FONT_XTINY, "ENTER: Concluir", Graphics.TEXT_JUSTIFY_CENTER);
    }
}
