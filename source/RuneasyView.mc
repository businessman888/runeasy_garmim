import Toybox.Activity;
import Toybox.Graphics;
import Toybox.Lang;
import Toybox.WatchUi;

class RuneasyView extends WatchUi.DataField {

    hidden var mPace as String;
    hidden var mDistance as String;
    hidden var mHR as String;
    hidden var mColorDark as Graphics.ColorValue;
    hidden var mColorElectricBlue as Graphics.ColorValue;
    hidden var AppLogo;
    hidden var logoWidth;
    hidden var HeartIcon;
    hidden var heartIconWidth;
    hidden var DistIcon;
    hidden var distIconWidth;

    function initialize() {
        DataField.initialize();
        mPace = "--:--";
        mDistance = "0.00";
        mHR = "--";
        mColorDark = 0x131F54 as Graphics.ColorValue;
        mColorElectricBlue = 0x00D4FF as Graphics.ColorValue;
    }

    function onLayout(dc as Dc) as Void {
        var obscurityFlags = DataField.getObscurityFlags();
        
        AppLogo = WatchUi.loadResource(Rez.Drawables.AppLogo) as WatchUi.BitmapResource;
        logoWidth = AppLogo.getWidth();
        
        HeartIcon = WatchUi.loadResource(Rez.Drawables.HeartIcon) as WatchUi.BitmapResource;
        heartIconWidth = HeartIcon.getWidth();

        DistIcon = WatchUi.loadResource(Rez.Drawables.DistIcon) as WatchUi.BitmapResource;
        distIconWidth = DistIcon.getWidth();

        if (obscurityFlags == (OBSCURE_TOP | OBSCURE_LEFT)) {
            View.setLayout(Rez.Layouts.TopLeftLayout(dc));
        } else if (obscurityFlags == (OBSCURE_TOP | OBSCURE_RIGHT)) {
            View.setLayout(Rez.Layouts.TopRightLayout(dc));
        } else if (obscurityFlags == (OBSCURE_BOTTOM | OBSCURE_LEFT)) {
            View.setLayout(Rez.Layouts.BottomLeftLayout(dc));
        } else if (obscurityFlags == (OBSCURE_BOTTOM | OBSCURE_RIGHT)) {
            View.setLayout(Rez.Layouts.BottomRightLayout(dc));
        } else {
            View.setLayout(Rez.Layouts.MainLayout(dc));
        }
    }

    function compute(info as Activity.Info) as Void {
        if (info has :currentSpeed && info.currentSpeed != null) {
            var speed = info.currentSpeed as Float;
            if (speed < 0.2f) {
                mPace = "--:--";
            } else {
                var paceDecimal = 1000.0f / (speed * 60.0f);
                var mins = paceDecimal.toNumber();
                var secs = ((paceDecimal - mins) * 60.0f).toNumber();
                mPace = mins.toString() + ":" + secs.format("%02d");
            }
        } else {
            mPace = "--:--";
        }

        var distance = 0.0f;
        if (info has :elapsedDistance && info.elapsedDistance != null) {
            distance = (info.elapsedDistance as Float) / 1000.0f;
        }
        mDistance = distance.format("%.2f");

        if (info has :currentHeartRate && info.currentHeartRate != null) {
            mHR = info.currentHeartRate.toString();
        } else {
            mHR = "--";
        }
    }

    function onUpdate(dc as Dc) as Void {
        var w = dc.getWidth();
        var h = dc.getHeight();
        var centerX = w / 2;
        var centerY = h / 2;

        // Passo 1 (Fundo): Defina a cor de fundo Premium Dark
        dc.setColor(Graphics.COLOR_TRANSPARENT, 0x131F54 as Graphics.ColorValue);
        dc.clear();

        // Passo 2 (Anel de Performance Radial - HR)
        var hrValue = mHR.equals("--") ? 0 : mHR.toNumber();
        if (hrValue > 240) { hrValue = 240; }
        var hrDegree = (hrValue * 360) / 240; 
        
        if (hrDegree > 0) {
            dc.setPenWidth(4); // Espessura bold para moldura da tela
            dc.setColor(0x00D4FF as Graphics.ColorValue, Graphics.COLOR_TRANSPARENT);
            var startDegree = 90;
            var endDegree = 90 - hrDegree;
            if (endDegree < 0) {
                endDegree += 360;
            }
            dc.drawArc(centerX, centerY, (w / 2) - 3, Graphics.ARC_CLOCKWISE, startDegree, endDegree);
        }

        var obscurityFlags = DataField.getObscurityFlags();
        var isQuadrant = (obscurityFlags == (OBSCURE_TOP | OBSCURE_LEFT)) || 
                         (obscurityFlags == (OBSCURE_TOP | OBSCURE_RIGHT)) || 
                         (obscurityFlags == (OBSCURE_BOTTOM | OBSCURE_LEFT)) || 
                         (obscurityFlags == (OBSCURE_BOTTOM | OBSCURE_RIGHT));

        if (!isQuadrant) {
            
            // 3.1 - Logo Centralizada no Topo com "respiro"
            if (AppLogo != null && logoWidth != null) {
                var logoY = h * 0.06; // Empurrada ligeiramente pro topo para abrir espaço
                dc.drawBitmap(centerX - (logoWidth/2), logoY, AppLogo);
            }

            // Propriedades do Glassmorphism "True Glass"
            var glassFillColor = 0x20326A as Graphics.ColorValue;
            var glassBorderColor = 0x3A508C as Graphics.ColorValue; // Borda sutil de 1px
            var boxPaddingX = 25; // Blocos horizontais largos

            // 3.2 - Bloco HR (Topo, centralizado)
            if (HeartIcon != null && heartIconWidth != null) {
                var hrFont = Graphics.FONT_LARGE; // Aumentado a escala da fonte
                var hrTextWidth = dc.getTextWidthInPixels(mHR, hrFont);
                var innerPadding = 8;
                var contentW = heartIconWidth + innerPadding + hrTextWidth;
                var boxW = contentW + (boxPaddingX * 2);
                var boxH = 40; 
                var boxX = centerX - (boxW / 2);
                var boxY = h * 0.24; // Abaixado para manter a hierarquia clara em relação à logo

                // Fundo e Borda do Bloco Glass
                dc.setColor(glassFillColor, Graphics.COLOR_TRANSPARENT);
                dc.fillRoundedRectangle(boxX, boxY, boxW, boxH, 12);
                dc.setPenWidth(1);
                dc.setColor(glassBorderColor, Graphics.COLOR_TRANSPARENT);
                dc.drawRoundedRectangle(boxX, boxY, boxW, boxH, 12);

                // Desenho Interno (Ícone + Valor perfeitamente centralizados verticalmente na caixa)
                var contentStartX = centerX - (contentW / 2);
                dc.drawBitmap(contentStartX, boxY + 10, HeartIcon);
                dc.setColor(0x00D4FF as Graphics.ColorValue, Graphics.COLOR_TRANSPARENT);
                dc.drawText(contentStartX + heartIconWidth + innerPadding, boxY + (boxH / 2), hrFont, mHR, Graphics.TEXT_JUSTIFY_LEFT | Graphics.TEXT_JUSTIFY_VCENTER);
            }

            // 3.3 - PACE Protagonista Absoluto (Centro)
            var valueView = View.findDrawableById("value") as Text;
            if (valueView != null) {
                valueView.setColor(0x00D4FF as Graphics.ColorValue);
                valueView.setText(mPace);
                // Subindo um pouco o Y central pois a fonte HOT tem muito padding inferior fantasma
                valueView.setLocation(centerX, centerY - 25);
                valueView.draw(dc);
            }

            // 3.4 - Bloco de Distância (Base, centralizado)
            if (DistIcon != null && distIconWidth != null) {
                var distFont = Graphics.FONT_LARGE; // Aumentado a escala da fonte
                var distTextWidth = dc.getTextWidthInPixels(mDistance, distFont);
                var innerPadding = 8;
                var contentW = distIconWidth + innerPadding + distTextWidth;
                var boxW = contentW + (boxPaddingX * 2);
                var boxH = 40;
                var boxX = centerX - (boxW / 2);
                var boxY = h * 0.82; // Empurrado bem para baixo para isolar do Pace

                // Fundo e Borda do Bloco Glass
                dc.setColor(glassFillColor, Graphics.COLOR_TRANSPARENT);
                dc.fillRoundedRectangle(boxX, boxY, boxW, boxH, 12);
                dc.setPenWidth(1);
                dc.setColor(glassBorderColor, Graphics.COLOR_TRANSPARENT);
                dc.drawRoundedRectangle(boxX, boxY, boxW, boxH, 12);

                // Desenho Interno (Ícone + Valor perfeitamente centralizados verticalmente)
                var contentStartX = centerX - (contentW / 2);
                dc.drawBitmap(contentStartX, boxY + 10, DistIcon);
                dc.setColor(0x00D4FF as Graphics.ColorValue, Graphics.COLOR_TRANSPARENT);
                dc.drawText(contentStartX + distIconWidth + innerPadding, boxY + (boxH / 2), distFont, mDistance, Graphics.TEXT_JUSTIFY_LEFT | Graphics.TEXT_JUSTIFY_VCENTER);
            }

        } else {
            // Tratamento Fallback Seguro
            var valueView = View.findDrawableById("value") as Text;
            if (valueView != null) {
                valueView.setColor(0x00D4FF as Graphics.ColorValue);
                valueView.setText(mPace);
                valueView.draw(dc);
            }

            var labelView = View.findDrawableById("label") as Text;
            if (labelView != null) {
                labelView.setColor(0x00D4FF as Graphics.ColorValue);
                labelView.setText(mDistance);
                labelView.draw(dc);
            }
        }
    }
}
