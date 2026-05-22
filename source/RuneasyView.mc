import Toybox.Activity;
import Toybox.Graphics;
import Toybox.Lang;
import Toybox.WatchUi;
import Toybox.Timer;

class RuneasyView extends WatchUi.View {

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
    hidden var mTimer as Timer.Timer?;
    
    hidden var mWorkoutName as String?;
    hidden var mTargetValue as String?;

    function initialize(workoutName as String?, targetValue as String?) {
        View.initialize();
        mPace = "--:--";
        mDistance = "0.00";
        mHR = "--";
        mColorDark = 0x131F54 as Graphics.ColorValue;
        mColorElectricBlue = 0x00D4FF as Graphics.ColorValue;
        mWorkoutName = workoutName;
        mTargetValue = targetValue;
    }

    function onLayout(dc as Dc) as Void {
        AppLogo = WatchUi.loadResource(Rez.Drawables.AppLogo) as WatchUi.BitmapResource;
        logoWidth = AppLogo.getWidth();
        
        HeartIcon = WatchUi.loadResource(Rez.Drawables.HeartIcon) as WatchUi.BitmapResource;
        heartIconWidth = HeartIcon.getWidth();

        DistIcon = WatchUi.loadResource(Rez.Drawables.DistIcon) as WatchUi.BitmapResource;
        distIconWidth = DistIcon.getWidth();

        View.setLayout(Rez.Layouts.MainLayout(dc));
    }

    function onShow() as Void {
        mTimer = new Timer.Timer();
        mTimer.start(method(:onTimer), 1000, true);
    }

    function onHide() as Void {
        if (mTimer != null) {
            mTimer.stop();
            mTimer = null;
        }
    }

    function onTimer() as Void {
        WatchUi.requestUpdate();
    }

    function onUpdate(dc as Dc) as Void {
        var info = Activity.getActivityInfo();
        if (info != null) {
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

        var w = dc.getWidth();
        var h = dc.getHeight();
        var centerX = w / 2;
        var centerY = h / 2;

        dc.setColor(Graphics.COLOR_TRANSPARENT, 0x0E0E1F);
        dc.clear();

        // Passo 2 (Anel de Performance Radial - HR)
        var hrValue = mHR.equals("--") ? 0 : mHR.toNumber();
        if (hrValue > 240) { hrValue = 240; }
        var hrDegree = (hrValue * 360) / 240; 
        
        var targetColor = 0x00D4FF as Graphics.ColorValue;
        if (mTargetValue != null) {
            targetColor = 0x00FF00 as Graphics.ColorValue; // Green for target active
        }
        
        if (hrDegree > 0) {
            dc.setPenWidth(4);
            dc.setColor(targetColor, Graphics.COLOR_TRANSPARENT);
            var startDegree = 90;
            var endDegree = 90 - hrDegree;
            if (endDegree < 0) {
                endDegree += 360;
            }
            dc.drawArc(centerX, centerY, (w / 2) - 3, Graphics.ARC_CLOCKWISE, startDegree, endDegree);
        }

        // 3.1 - Logo Centralizada no Topo com "respiro" (Y = 4% da tela para evitar sobreposição)
        var logoY = (h * 0.04).toNumber();
        var logoH = 0;
        if (AppLogo != null && logoWidth != null) {
            dc.drawBitmap(centerX - (logoWidth/2), logoY, AppLogo);
            logoH = AppLogo.getHeight();
        }
        var logoBottom = logoY + logoH;

        // Respiro dinâmico: 5% para telas pequenas (<= 240px) e 6% para telas maiores
        var spacingGap = (h <= 240) ? (h * 0.05).toNumber() : (h * 0.06).toNumber();

        // 3.2 - Card de BPM (Top): Y = Logo_Bottom + spacingGap
        var hrY = logoBottom + spacingGap;
        
        // 3.3 - Card de KM (Bottom): Posicionado de forma fixa e segura a 68% da altura da tela
        // Isso evita que ele fique muito abaixo e seja cortado pela borda física circular em relógios menores e maiores
        var distY = (h * 0.68).toNumber();

        // 3.4 - Contador Central: Centralizado visualmente no espaço livre restante entre o card de BPM e o card de KM
        var centralFont = (h <= 240) ? Graphics.FONT_NUMBER_MEDIUM : Graphics.FONT_NUMBER_HOT;

        // O card de BPM começa em hrY. Para obter a altura do card de BPM (cardH):
        var valueFont = Graphics.FONT_LARGE;
        var unitFont = Graphics.FONT_TINY;
        var valueFontH = dc.getFontHeight(valueFont);
        var unitFontH = dc.getFontHeight(unitFont);
        var iconH = HeartIcon != null ? HeartIcon.getHeight() : 24;
        
        var maxContentH = iconH;
        if (valueFontH > maxContentH) {
            maxContentH = valueFontH;
        }
        if (unitFontH > maxContentH) {
            maxContentH = unitFontH;
        }
        var vertPadding = 5;
        var cardH = maxContentH + (2 * vertPadding);
        
        var hrBottom = hrY + cardH;

        // O espaço livre vertical fica entre hrBottom e distY.
        // O centro físico deste espaço livre é:
        var timerCenterY = (hrBottom + distY) / 2;

        // Desenhar os elementos
        if (HeartIcon != null) {
            drawGlassCard(dc, hrY, mHR, HeartIcon, "bpm");
        }

        // Desenhamos o cronômetro centralizado perfeitamente (verticalmente e horizontalmente) no meio do espaço livre restante
        dc.setColor(0x00D4FF as Graphics.ColorValue, Graphics.COLOR_TRANSPARENT);
        dc.drawText(centerX, timerCenterY, centralFont, mPace, Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);

        if (DistIcon != null) {
            drawGlassCard(dc, distY, mDistance, DistIcon, "km");
        }
    }

    private function drawGlassCard(dc, y, value, icon, unit) {
        var w = dc.getWidth();
        
        var valueFont = Graphics.FONT_LARGE;
        var unitFont = Graphics.FONT_TINY;
        
        var valueW = dc.getTextWidthInPixels(value, valueFont);
        var unitW = dc.getTextWidthInPixels(unit, unitFont);
        
        var iconW = icon.getWidth();
        var iconH = icon.getHeight();
        
        var horizPadding = 14;
        var vertPadding = 5; // Compacted to 5px (safe range 4-6px) to reduce vertical height
        var spacing = 8;
        
        var cardW = horizPadding + iconW + spacing + valueW + spacing + unitW + horizPadding;
        
        var valueFontH = dc.getFontHeight(valueFont);
        var unitFontH = dc.getFontHeight(unitFont);
        
        var maxContentH = iconH;
        if (valueFontH > maxContentH) {
            maxContentH = valueFontH;
        }
        if (unitFontH > maxContentH) {
            maxContentH = unitFontH;
        }
        
        var cardH = maxContentH + (2 * vertPadding);
        var cardX = (w - cardW) / 2;
        
        var glassFillColor = 0x1E1E38 as Graphics.ColorValue; 
        var glassBorderColor = 0x2E2E5C as Graphics.ColorValue; 
        
        dc.setColor(glassFillColor, Graphics.COLOR_TRANSPARENT);
        dc.fillRoundedRectangle(cardX, y, cardW, cardH, 12);
        dc.setPenWidth(1);
        dc.setColor(glassBorderColor, Graphics.COLOR_TRANSPARENT);
        dc.drawRoundedRectangle(cardX, y, cardW, cardH, 12);
        
        var centerY = y + (cardH / 2);
        
        // Draw Icon
        var iconX = cardX + horizPadding;
        var iconY = centerY - (iconH / 2);
        dc.drawBitmap(iconX, iconY, icon);
        
        // Draw Value
        var valueX = iconX + iconW + spacing;
        dc.setColor(0xFFFFFF as Graphics.ColorValue, Graphics.COLOR_TRANSPARENT);
        dc.drawText(valueX, centerY, valueFont, value, Graphics.TEXT_JUSTIFY_LEFT | Graphics.TEXT_JUSTIFY_VCENTER);
        
        // Draw Unit
        var unitX = valueX + valueW + spacing;
        dc.setColor(0x00D4FF as Graphics.ColorValue, Graphics.COLOR_TRANSPARENT);
        dc.drawText(unitX, centerY, unitFont, unit, Graphics.TEXT_JUSTIFY_LEFT | Graphics.TEXT_JUSTIFY_VCENTER);
    }
}
