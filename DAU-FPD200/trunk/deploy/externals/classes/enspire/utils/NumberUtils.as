class enspire.utils.NumberUtils{
	public static function insertThousandsSeparator(temp:Number, addZeros,  sep:String) {
		if (sep == undefined) {
			sep = ",";
		}
		
		////trace("insertThousandsSeparator("+temp+")");
		var isNegative = false;
		if (temp < 0) {
			isNegative = true;
		}
		////trace("after fix negitive"+temp+")");
		var num = temp.toString();
	
		if(isNegative) {
			num = num.slice(1);
		}
		// Determine the location after the one's place
		var endInt = 0;
	
		var dotIdx = num.indexOf(".");
		if (dotIdx != -1)
			endInt = Math.min(num.indexOf("."), num.length);
			
		else
			endInt = num.length;
	
		// Insert thousands separators into num
		for (var i=endInt-3; i>0; i-=3) {
			num = num.slice(0, i) + sep + num.slice(i);
		}
		
		
		return isNegative ? "("+num+")" : num;
	}
	public static function getNumberFromString(s:String) {
		var aNum = s.split("");
		var sNum = "";
		var isNegative = false;
		
		for(var i = 0; i < aNum.length; i++) {
			if(((aNum[i] == "(") || (aNum[i] == "-")) && (i == 0)) {
				isNegative = true;
			}
			if((!isNaN(aNum[i])) || (aNum[i] == ".")) {
				sNum += aNum[i];
			}
		}
		
		var rNum = isNegative ? "-"+sNum : sNum
		////trace("Number from string "+rNum+" isNeg: "+isNegative+" org string: "+s);
		return rNum;
		
	}
	public static function compare(n1:Number, n2:Number) {
		n1 = formatDecimals(n1, 2);
		n2 = formatDecimals(n2, 2);
		////trace("Number Utils Number Compare "+n1+" : "+n2+" = "+(n1.valueOf() == n2.valueOf()));
		if(n1.valueOf() == n2.valueOf()) {
			return true;
		}else{
			return false;
		}
	}
	public static function compareRange(n:Number, r1:Number, r2:Number, bFormat:Boolean) {
		//trace("Number Utils Number Compare range "+n+" range: "+r1+" - "+r2);
		if((isNaN(n)) || (isNaN(r1)) || (isNaN(r2))) {
			return false;
		}
		
		if(bFormat != false) {
			n = formatDecimals(n, 2);
			r1 = formatDecimals(r1, 2);
			r2 = formatDecimals(r2, 2);
		}
		
		
		//trace("Number Utils Number Compare range "+n+" range: "+r1+" - "+r2+" = "+((n.valueOf() >= r1.valueOf()) && (n.valueOf() <= r2.valueOf())));
		if((n.valueOf() >= r1.valueOf()) && (n <= r2.valueOf())) {
			return true;
		}else{
			return false;
		}
		
	}
	public static function compareSeries(n:Number, aSeries:Array) {
		for(var i:Number = 0; i < aSeries.length; i++) {
			var n2 = formatDecimals(aSeries[i], 2);
			var isMatch:Boolean = compare(n, n2);
			if(isMatch) {
				return true;
			}
		}
		return false;
		
	}
	
	public static function formatDecimals(num, digits) {
        //if no decimal places needed, we're done
		if(num == "") {
			return;
		}
		
		if (digits <= 0) {
				return Math.round(num);
		}
			//round the number to specified decimal places
			//e.g. 12.3456 to 3 digits (12.346) -> mult. by 1000, round, div. by 1000
		var tenToPower = Math.pow(10, digits);
		var cropped = String(Math.round(num * tenToPower) / tenToPower);
		//add decimal point if missing
		if (cropped.indexOf(".") == -1) {
				cropped += ".0"; //e.g. 5 -> 5.0 (at least one zero is needed)
		}
			
		//finally, force correct number of zeroes; add some if necessary
		var halves = cropped.split("."); //grab numbers to the right of the decimal
		//compare digits in right half of string to digits wanted
		var zerosNeeded = digits - halves[1].length; //number of zeros to add
		for (var i=1; i <= zerosNeeded; i++) {
				cropped += "0";
		}
		return(cropped);
	}
	
	public static function randInt(minInt:Number, maxInt:Number) {
		if (minInt <= maxInt)
			return Math.floor(Math.random() * (maxInt-minInt+1)) + minInt;
		else   // minInt > maxInt -- ILLEGAL
			return null;
	}
	public static function sum(numArr:Array) {
		var total:Number = 0;
		
		if (numArr != null) {
			for (var i=0; i<numArr.length; i++) {
				if(!isNaN(numArr[i])) {
					total += numArr[i];
				}
			}
		}
		return total;
	}
	public static function mean(numArr:Array) {
		return sum(numArr) / numArr.length;
	}
	public static function variance(numArr:Array) {
		var mean:Number = mean(numArr);
		// Calculate sum of (x - mean)^2 for each x in numArr
		var sumSquares:Number = 0;
		for (var i=0; i<numArr.length; i++) {
			var diffMean:Number = numArr[i] - mean;
			sumSquares += diffMean * diffMean;
		}
	
		return sumSquares / (numArr.length-1);
	}
	public static function deviance(numArr:Number) {
		// standard deviance is simply the square root of the variance
		return Math.sqrt(variance(numArr));
	}
	public static function clamp(num:Number, minVal:Number, maxVal:Number) {
		if (isNaN(num)) {
			num = 0;
		}
		return Math.max(minVal, Math.min(num, maxVal));
	}


}
