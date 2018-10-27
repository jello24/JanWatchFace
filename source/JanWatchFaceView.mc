using Toybox.WatchUi;
using Toybox.Graphics;
using Toybox.System;
using Toybox.Lang;
using Toybox.Application;
using Toybox.Time.Gregorian as Calendar;

class JanWatchFaceView extends WatchUi.WatchFace {

	var txt_lrg, txt_med, txt_hr;
	
	var watch_width, watch_height;
	var center_x, center_y;
	
	var numToWords = ["o'clock", "one", "two", "three", "four", "five", "six", "seven", "eight", "nine", "ten", 
		"eleven", "twelve", "thirteen", "fourteen", "fifteen", "sixteen", "seventeen", "eighteen", "nineteen", 
		"twenty", "thirty", "forty", "fifty", "sixty"];

    function initialize() {
        WatchFace.initialize();
    }

    // Load your resources here
    function onLayout(dc) {
    	watch_width = dc.getWidth();
    	watch_height = dc.getHeight();
    	
    	center_x = watch_width / 2;
    	center_y = watch_height / 2;
    	
    	System.print(watch_width + ", " + watch_height + ", " + center_x + ", " + center_y + "\n");
    	
    	txt_lrg = loadResource(Rez.Fonts.txt_lrg);
    	txt_med = loadResource(Rez.Fonts.txt_med);
    	txt_hr = loadResource(Rez.Fonts.txt_hr);
    	
        setLayout(Rez.Layouts.WatchFace(dc));
    }

    // Called when this View is brought to the foreground. Restore
    // the state of this View and prepare it to be shown. This includes
    // loading resources into memory.
    function onShow() {
    }

    // Update the view
    function onUpdate(dc) {
    
    	//var priClr = Graphics.COLOR_DK_GREEN;
    	var priClr = 0x00FA9A;
    	var secClr = Graphics.COLOR_WHITE;
    	var bgClr = Graphics.COLOR_BLACK;
    	var trClr = Graphics.COLOR_TRANSPARENT;
    	
    	dc.setColor(bgClr, bgClr);
    	dc.clear();
    	
        // Get the current time and format it correctly
        var timeFormat = "$1$:$2$";
        var clockTime = System.getClockTime();
        var hours = clockTime.hour;
        var min = clockTime.min;
        var minStr = numToWords[0];
        
        // Testing Purposes Only       
        hours = 11;
        min = 27;
        ////////////////////////
        
        if (!System.getDeviceSettings().is24Hour) {
            if (hours > 12) {
                hours = hours - 12;
            }
            
            if(hours == 0)
            {
            	hours = 12;
            }
        } 
        
        // Turn the hours into a string
		var hourStr = numToWords[hours];
		
		System.print(hours + " - " + hourStr + "\n");
		
		// Calculate minStr
		if(min > 49) // 50+
		{
			var minLower = min % 50;
			if(minLower == 0)
			{
				minStr = numToWords[23];
			}
			else
			{
				minStr = numToWords[23] + "-" + numToWords[minLower];
			}
			
		}
		else if((min > 39) && (min < 50)) // 40 - 49
		{
			var minLower = min % 40;
			if(minLower == 0)
			{
				minStr = numToWords[22];
			}
			else
			{
				minStr = numToWords[22] + "-" + numToWords[minLower];
			}
		}		
        else if((min > 29) && (min < 40)) // 30 - 39
		{
			var minLower = min % 30;
			if(minLower == 0)
			{
				minStr = numToWords[21];
			}
			else
			{
				minStr = numToWords[21] + "-" + numToWords[minLower];
			}
		}
		else if((min > 19) && (min < 30)) // 20 - 29
		{
			var minLower = min % 20;
			if(minLower == 0)
			{
				minStr = numToWords[20];
			}
			else
			{
				minStr = numToWords[20] + "-" + numToWords[minLower];
			}
		}
		else if((min > 0) && (min < 10)) // 20 - 29
		{
			
			minStr = "o' " + numToWords[min];
		}
		else
		{
			minStr = numToWords[min];
		}

		System.print(min + " - " + minStr + "\n");
		
        //var timeString = Lang.format(timeFormat, [hour, clockTime.min.format("%02d")]);
        
        // Get the date and format it
        var info = Calendar.info(Time.now(), Time.FORMAT_LONG);
        var fullDateString = Lang.format("$1$, $2$ $3$", [info.day_of_week, info.month, info.day]);
        var dateString = Lang.format("$1$", [info.day]);

        // Update the view
        //System.print(timeString + " " + dateString + "\n");
        
        
        //dc.drawText(center_x, center_y - 20, led_lrg, timeString, Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);
        //dc.drawText(center_x, center_y + 80, led_med, dateString, Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);
        dc.setColor(priClr, trClr);
        dc.drawText(15, center_y - 40, txt_hr, hourStr, Graphics.TEXT_JUSTIFY_LEFT | Graphics.TEXT_JUSTIFY_VCENTER);
        dc.drawRectangle(0, center_y + 30, watch_width, 2);
        dc.drawText(center_x, center_y + 52, txt_med, info.day_of_week, Graphics.TEXT_JUSTIFY_RIGHT | Graphics.TEXT_JUSTIFY_VCENTER);
        
        dc.setColor(secClr, trClr);
        dc.drawText(15, center_y, txt_lrg, minStr, Graphics.TEXT_JUSTIFY_LEFT | Graphics.TEXT_JUSTIFY_VCENTER);
        dc.drawText(center_x, center_y + 52, txt_med, " " + info.day, Graphics.TEXT_JUSTIFY_LEFT | Graphics.TEXT_JUSTIFY_VCENTER);
        
        // Show bluetooth and mail icon
        var offset = 0;
        
		if (System.getDeviceSettings().phoneConnected) 
		{ 
			if (System.getDeviceSettings().notificationCount > 0)
			{
				offset = 20;  
				dc.drawBitmap(center_x - 8+ offset, center_y + 80, loadResource(Rez.Drawables.MailIcon));
			}
			dc.drawBitmap(center_x -8 + (-1 * offset), center_y + 80, loadResource(Rez.Drawables.BTIcon));
		}
		
    }

    // Called when this View is removed from the screen. Save the
    // state of this View here. This includes freeing resources from
    // memory.
    function onHide() {
    }

    // The user has just looked at their watch. Timers and animations may be started here.
    function onExitSleep() {
    }

    // Terminate any active timers and prepare for slow updates.
    function onEnterSleep() {
    }

}
