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

        // No início do onUpdate(dc)
        dc.setColor(Graphics.COLOR_TRANSPARENT, 0x0E0E1F); // Define cor de fundo dark navy
        dc.clear(); // Limpa a tela inteira com esta cor

        // Título Superior
        dc.setColor(0xFFFFFF as Graphics.ColorValue, Graphics.COLOR_TRANSPARENT);
        dc.drawText(centerX, h * 0.12, Graphics.FONT_XTINY, "Treinos do dia", Graphics.TEXT_JUSTIFY_CENTER);

        // Glass Card for Workout of the Day (Estilo Screenshot 3 e 4)
        var cardW = w * 0.8;
        var cardH = h * 0.45;
        var cardX = (w - cardW) / 2;
        var cardY = h * 0.25;

        var workoutCompleted = Toybox.Application.Storage.getValue("workout_completed");
        
        var fontXTinyH = dc.getFontHeight(Graphics.FONT_XTINY);
        var fontTinyH = dc.getFontHeight(Graphics.FONT_TINY);
        var linePadding = 5;

        if (workoutCompleted != null && workoutCompleted) {
            // Fundo do Card - Verde/Neon indicando Concluído (Opaco e limpo)
            dc.setColor(0x1E1E38 as Graphics.ColorValue, Graphics.COLOR_TRANSPARENT);
            dc.fillRoundedRectangle(cardX, cardY, cardW, cardH, 16);
            dc.setPenWidth(2);
            dc.setColor(0x00FF88 as Graphics.ColorValue, Graphics.COLOR_TRANSPARENT);
            dc.drawRoundedRectangle(cardX, cardY, cardW, cardH, 16);

            // Conteúdo do Card Concluído - Calculado dinamicamente com base nas alturas das fontes
            var y1 = cardY + 12;
            dc.setColor(0x00FF88 as Graphics.ColorValue, Graphics.COLOR_TRANSPARENT);
            dc.drawText(centerX, y1, Graphics.FONT_XTINY, "TREINO CONCLUÍDO", Graphics.TEXT_JUSTIFY_CENTER);
            
            var y2 = y1 + fontXTinyH + linePadding;
            dc.setColor(0xFFFFFF as Graphics.ColorValue, Graphics.COLOR_TRANSPARENT);
            dc.drawText(centerX, y2, Graphics.FONT_TINY, "Bom trabalho!", Graphics.TEXT_JUSTIFY_CENTER);

            // Status de Sincronização no card
            var syncStatus = Toybox.Application.Storage.getValue("sync_status");
            var statusText = "Enviando dados...";
            if (syncStatus != null) {
                if (syncStatus.equals("SYNCED")) {
                    statusText = "Dados Enviados";
                } else if (syncStatus.equals("PENDING")) {
                    statusText = "Envio Pendente";
                }
            }
            var y3 = y2 + fontTinyH + linePadding;
            dc.setColor(0x00D4FF as Graphics.ColorValue, Graphics.COLOR_TRANSPARENT);
            dc.drawText(centerX, y3, Graphics.FONT_XTINY, statusText, Graphics.TEXT_JUSTIFY_CENTER);

            // Botão de Ação / Dica - Formato Cápsula Oval (Largura controlada 65%)
            var btnW = w * 0.65;
            var btnH = 34;
            var btnX = (w - btnW) / 2;
            var btnY = h * 0.82 - (btnH / 2);
            
            dc.setColor(0x00FF88 as Graphics.ColorValue, Graphics.COLOR_TRANSPARENT);
            dc.fillRoundedRectangle(btnX, btnY, btnW, btnH, btnH / 2);
            dc.setColor(0x0E0E1F as Graphics.ColorValue, Graphics.COLOR_TRANSPARENT);
            dc.drawText(centerX, btnY + (btnH / 2), Graphics.FONT_XTINY, "ENTER: Fechar App", Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);
        } else {
            // Fundo do Card padrão
            dc.setColor(0x1E1E38 as Graphics.ColorValue, Graphics.COLOR_TRANSPARENT);
            dc.fillRoundedRectangle(cardX, cardY, cardW, cardH, 16);
            dc.setPenWidth(2);
            dc.setColor(0x00D4FF as Graphics.ColorValue, Graphics.COLOR_TRANSPARENT);
            dc.drawRoundedRectangle(cardX, cardY, cardW, cardH, 16);

            // Conteúdo do Card padrão - Calculado dinamicamente com base nas alturas das fontes
            var y1 = cardY + 12;
            dc.setColor(0x00D4FF as Graphics.ColorValue, Graphics.COLOR_TRANSPARENT);
            dc.drawText(centerX, y1, Graphics.FONT_XTINY, "ALTA INTENSIDADE", Graphics.TEXT_JUSTIFY_CENTER);
            
            var y2 = y1 + fontXTinyH + linePadding;
            dc.setColor(0xFFFFFF as Graphics.ColorValue, Graphics.COLOR_TRANSPARENT);
            dc.drawText(centerX, y2, Graphics.FONT_TINY, "Intervalados", Graphics.TEXT_JUSTIFY_CENTER);
            
            var y3 = y2 + fontTinyH + linePadding;
            dc.drawText(centerX, y3, Graphics.FONT_SMALL, "8x400m", Graphics.TEXT_JUSTIFY_CENTER);

            // Botão de Ação / Dica padrão - Formato Cápsula Oval (Largura controlada 65%)
            var btnW = w * 0.65;
            var btnH = 34;
            var btnX = (w - btnW) / 2;
            var btnY = h * 0.82 - (btnH / 2);
            
            dc.setColor(0x00D4FF as Graphics.ColorValue, Graphics.COLOR_TRANSPARENT);
            dc.fillRoundedRectangle(btnX, btnY, btnW, btnH, btnH / 2);
            dc.setColor(0x0E0E1F as Graphics.ColorValue, Graphics.COLOR_TRANSPARENT);
            dc.drawText(centerX, btnY + (btnH / 2), Graphics.FONT_XTINY, "ENTER: Ver Detalhes", Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);
        }

        // Feedback de Status: Ícone de Nuvem / Pendente (Deferred Sync) - Zonas Seguras de Circunferência
        var syncStatus = Toybox.Application.Storage.getValue("sync_status");
        if (syncStatus != null && syncStatus.equals("PENDING")) {
            var titleW = dc.getTextWidthInPixels("Treinos do dia", Graphics.FONT_XTINY);
            var titleH = dc.getFontHeight(Graphics.FONT_XTINY);
            var alertX = centerX + (titleW / 2) + 14;
            var alertY = (h * 0.12) + (titleH / 2);

            // Desenha um ponto laranja discreto como alerta próximo ao título (área segura)
            dc.setColor(0xFF8C00 as Graphics.ColorValue, Graphics.COLOR_TRANSPARENT); 
            dc.fillCircle(alertX, alertY, 6);
            dc.setColor(0xFFFFFF as Graphics.ColorValue, Graphics.COLOR_TRANSPARENT);
            dc.drawText(alertX, alertY, Graphics.FONT_XTINY, "!", Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);
        }
    }
}
