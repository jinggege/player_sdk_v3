package com.laifeng.view.input
{
	import flash.utils.Dictionary;

	public class KeyCodeMap
	{
		
		private static var dictEn0:Dictionary;
		private static var dictEn1:Dictionary;
		
		private static var dictCh0:Dictionary;
		private static var dictCh1:Dictionary;
		
		dictEn0 = new Dictionary;
		dictEn1 = new Dictionary;
		
		dictEn0[48] = "0";
		dictEn1[48] = ")";
		dictEn0[49] = "1";
		dictEn1[49] = "!";
		dictEn0[50] = "2";
		dictEn1[50] = "@";
		dictEn0[51] = "3";
		dictEn1[51] = "#";
		dictEn0[52] = "4";
		dictEn1[52] = "$";
		dictEn0[53] = "5";
		dictEn1[53] = "%";
		dictEn0[54] = "6";
		dictEn1[54] = "^";
		dictEn0[55] = "7";
		dictEn1[55] = "&";
		dictEn0[56] = "8";
		dictEn1[56] = "*";
		dictEn0[57] = "9";
		dictEn1[57] = "(";
		
		
		dictEn0[96] = "0";
		dictEn1[96] = "0";
		dictEn0[97] = "1";
		dictEn1[97] = "1";
		dictEn0[98] = "2";
		dictEn1[98] = "2";
		dictEn0[99] = "3";
		dictEn1[99] = "3";
		dictEn0[100] = "4";
		dictEn1[100] = "4";
		dictEn0[101] = "5";
		dictEn1[101] = "5";
		dictEn0[102] = "6";
		dictEn1[102] = "6";
		dictEn0[103] = "7";
		dictEn1[103] = "7";
		dictEn0[104] = "8";
		dictEn1[104] = "8";
		dictEn0[105] = "9";
		dictEn1[105] = "9";
		dictEn0[106] = "*";
		dictEn1[106] = "*";
		dictEn0[107] = "+";
		dictEn1[107] = "+";
		dictEn0[109] = "-";
		dictEn1[109] = "-";
		dictEn0[110] = ".";
		dictEn1[110] = ".";
		dictEn0[111] = "/";
		dictEn1[111] = "/";
		
		
		dictEn0[186] = ";";
		dictEn1[186] = ":";
		dictEn0[187] = "=";
		dictEn1[187] = "+";
		dictEn0[188] = ",";
		dictEn1[188] = "<";
		dictEn0[189] = "-";
		dictEn1[189] = "_";
		dictEn0[190] = ".";
		dictEn1[190] = ">";
		dictEn0[191] = "/";
		dictEn1[191] = "?";
		dictEn0[192] = "`";
		dictEn1[192] = "~";
		
		dictEn0[219] = "[";
		dictEn1[219] = "{";
		dictEn0[220] = "\\";
		dictEn1[220] = "|";
		dictEn0[221] = "]";
		dictEn1[221] = "}";
		dictEn0[222] = "'";
		dictEn1[222] = "\"";
		
		//ch
		dictCh0 = new Dictionary;
		dictCh1 = new Dictionary;
		
		dictCh0[48] = "0";
		dictCh1[48] = "）";
		dictCh0[49] = "1";
		dictCh1[49] = "！";
		dictCh0[50] = "2";
		dictCh1[50] = "@";
		dictCh0[51] = "3";
		dictCh1[51] = "#";
		dictCh0[52] = "4";
		dictCh1[52] = "#";
		dictCh0[53] = "5";
		dictCh1[53] = "%";
		dictCh0[54] = "6";
		dictCh1[54] = "…";
		dictCh0[55] = "7";
		dictCh1[55] = "&";
		dictCh0[56] = "8";
		dictCh1[56] = "*";
		dictCh0[57] = "9";
		dictCh1[57] = "（";
		
		dictCh0[96] = "0";
		dictCh1[96] = "0";
		dictCh0[97] = "1";
		dictCh1[97] = "1";
		dictCh0[98] = "2";
		dictCh1[98] = "2";
		dictCh0[99] = "3";
		dictCh1[99] = "3";
		dictCh0[100] = "4";
		dictCh1[100] = "4";
		dictCh0[101] = "5";
		dictCh1[101] = "5";
		dictCh0[102] = "6";
		dictCh1[102] = "6";
		dictCh0[103] = "7";
		dictCh1[103] = "7";
		dictCh0[104] = "8";
		dictCh1[104] = "8";
		dictCh0[105] = "9";
		dictCh1[105] = "9";
		dictCh0[106] = "*";
		dictCh1[106] = "*";
		dictCh0[107] = "+";
		dictCh1[107] = "+";
		dictCh0[109] = "-";
		dictCh1[109] = "-";
		dictCh0[110] = ".";
		dictCh1[110] = ".";
		dictCh0[111] = "/";
		dictCh1[111] = "/";
		
		dictCh0[186] = "；";
		dictCh1[186] = "：";
		dictCh0[187] = "=";
		dictCh1[187] = "+";
		dictCh0[188] = "，";
		dictCh1[188] = "《";
		dictCh0[189] = "-";
		dictCh1[189] = "—";
		dictCh0[190] = "。";
		dictCh1[190] = "》";
		dictCh0[191] = "、";
		dictCh1[191] = "？";
		dictCh0[192] = "·";
		dictCh1[192] = "~";
		
		dictCh0[219] = "【";
		dictCh1[219] = "{";
		dictCh0[220] = "、";
		dictCh1[220] = "|";
		dictCh0[221] = "】";
		dictCh1[221] = "}";
		dictCh0[222] = "'";
		dictCh1[222] = "\"";
		//dictCh0[222] = "‘";
		//dictCh1[222] = "“";
		
		public function KeyCodeMap()
		{
		}
		
		public static function getString(keyCode:uint, lang:int, shift:Boolean):String
		{
			if (lang == 1)
			{
				if (shift)
					return dictCh1[keyCode];
				else
					return dictCh0[keyCode];
			}
			else
			{
				if (shift)
					return dictEn1[keyCode];
				else
					return dictEn0[keyCode];
			}
		}
		
	}
}