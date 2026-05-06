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

        // Passo 1 (Fundo): Defina a cor de fundo Premium Dark
        dc.setColor(Graphics.COLOR_TRANSPARENT, 0x131F54 as Graphics.ColorValue);
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

        // 3.1 - Logo Centralizada no Topo com "respiro"
        if (AppLogo != null && logoWidth != null) {
            var logoY = h * 0.04;
            dc.drawBitmap(centerX - (logoWidth/2), logoY, AppLogo);
        }

        if (mWorkoutName != null) {
            dc.setColor(0xFFFFFF as Graphics.ColorValue, Graphics.COLOR_TRANSPARENT);
            dc.drawText(centerX, h * 0.15, Graphics.FONT_XTINY, mWorkoutName, Graphics.TEXT_JUSTIFY_CENTER);
        }

        // 3.2 - Bloco HR (Topo, centralizado)
        if (HeartIcon != null) {
            var hrY = (mWorkoutName != null) ? h * 0.28 : h * 0.24;
            var boxW = 140;
            var boxH = 40;
            var boxX = centerX - (boxW / 2);
            drawGlassCard(dc, boxX, hrY, boxW, boxH, mHR, HeartIcon, "bpm");
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
        if (DistIcon != null) {
            var boxW = 140;
            var boxH = 40;
            var boxX = centerX - (boxW / 2);
            drawGlassCard(dc, boxX, h * 0.82, boxW, boxH, mDistance, DistIcon, "km");
        }
    }

    private function drawGlassCard(dc, x, y, width, height, value, icon, unit) {
        var glassFillColor = 0x20326A as Graphics.ColorValue; 
        var glassBorderColor = 0x3A508C as Graphics.ColorValue; 
        
        dc.setColor(glassFillColor, Graphics.COLOR_TRANSPARENT);
        dc.fillRoundedRectangle(x, y, width, height, 12);
        dc.setPenWidth(1);
        dc.setColor(glassBorderColor, Graphics.COLOR_TRANSPARENT);
        dc.drawRoundedRectangle(x, y, width, height, 12);

        var font = Graphics.FONT_LARGE;
        var textWidth = dc.getTextWidthInPixels(value, font);
        var unitFont = Graphics.FONT_TINY;
        var unitWidth = dc.getTextWidthInPixels(unit, unitFont);
        
        var iconW = 24; // Estimativa padrão do tamanho do ícone
        var innerPadding = 6;
        var contentW = iconW + innerPadding + textWidth + innerPadding + unitWidth;
        var contentStartX = x + (width - contentW) / 2;

        dc.drawBitmap(contentStartX, y + (height - iconW) / 2, icon);
        
        dc.setColor(0xFFFFFF as Graphics.ColorValue, Graphics.COLOR_TRANSPARENT);
        dc.drawText(contentStartX + iconW + innerPadding, y + (height / 2), font, value, Graphics.TEXT_JUSTIFY_LEFT | Graphics.TEXT_JUSTIFY_VCENTER);
        
        dc.setColor(0x00D4FF as Graphics.ColorValue, Graphics.COLOR_TRANSPARENT);
        dc.drawText(contentStartX + iconW + innerPadding + textWidth + innerPadding, y + (height / 2), unitFont, unit, Graphics.TEXT_JUSTIFY_LEFT | Graphics.TEXT_JUSTIFY_VCENTER);
    }
}
