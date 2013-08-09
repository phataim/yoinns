/**
 * Copyright:   Copyright (c)
 * Company:     dream3.cn
 * @author:     uncle
 * $Revision: 1.1 $
 */


 /*����Բ�������ַ������������ڶ���,������ĺ���Ϊ:˳�����������������ֵ��,�м��*/   
  String.prototype.createDate   =   function(){   
  var   regThree   =   /^\D*(\d{2,4})\D+(\d{1,2})\D+(\d{1,2})\D*$/;   
  var   regSix   =   /^\D*(\d{2,4})\D+(\d{1,2})\D+(\d{1,2})\D+(\d{1,2})\D+(\d{1,2})\D+(\d{1,2})\D*$/;   
  var   str   =   "";   
  var   date   =   null;   
  if(regThree.test(this)){   
  str   =   this.replace(/\s/g,"").replace(regThree,"$1/$2/$3");   
  date   =   new   Date(str);   
  }   
  else   if(regSix.test(this)){   
  str   =   this.match(regSix);   
  date   =   new   Date(str[1],str[2]-1,str[3],str[4],str[5],str[6]);   
  }   
  if(isNaN(date)) return   new   Date();   
  else   return   date;   
  }   
    
  /*   
    *   ����:����������ʽ���������ַ���   
    *   ����:dateFmt:�ַ���,�����½ṹ���           
    *             yy:��д��,YY:��д��mm:������,MM:Ӣ����,dd:��,hh:ʱ,   
    *             mi:��,ss��,ms:����,we:��������,WE:Ӣ������.   
    *             isFmtWithZero   :   �Ƿ���0���и�ʽ��,true   or   false   
  */   
  Date.prototype.parseString   =   function(dateFmt,isFmtWithZero){   
  dateFmt   =   (dateFmt   ==   null?"yy-mm-dd"   :   dateFmt);   
  isFmtWithZero   =   (isFmtWithZero   ==   null?true   :   isFmtWithZero);   
  if(typeof(dateFmt)   !=   "string"   )   
  throw   (new   Error(-1,   'parseString()������Ҫ�ַ������Ͳ���!'));   
  var   weekArr=[["������","����һ","���ڶ�","������","������","������","������"],   
      ["SUN","MON","TUR","WED","THU","FRI","SAT"]];   
  var   monthArr=["JAN","FEB","MAR","APR","MAY","JUN","JUL","AUG","SEP","OCT","NOV","DEC"];   
  var   str=dateFmt;   
  str   =   str.replace(/yy/g,this.getFullYear());   
  str   =   str.replace(/YY/g,this.getYear());   
  str   =   str.replace(/mm/g,(this.getMonth()+1).toString().fmtWithZero(isFmtWithZero));   
  str   =   str.replace(/MM/g,monthArr[this.getMonth()]);   
  str   =   str.replace(/dd/g,this.getDate().toString().fmtWithZero(isFmtWithZero));   
  str   =   str.replace(/hh/g,this.getHours().toString().fmtWithZero(isFmtWithZero));   
  str   =   str.replace(/mi/g,this.getMinutes().toString().fmtWithZero(isFmtWithZero));   
  str   =   str.replace(/ss/g,this.getSeconds().toString().fmtWithZero(isFmtWithZero));   
  str   =   str.replace(/ms/g,this.getMilliseconds().toString().fmtWithZeroD(isFmtWithZero));   
  str   =   str.replace(/we/g,weekArr[0][this.getDay()]);   
  str   =   str.replace(/WE/g,weekArr[1][this.getDay()]);   
  return   str;   
  }   
  /*��һλ���ָ�ʽ������λ,��:   9   to   09*/   
  String.prototype.fmtWithZero   =   function(isFmtWithZero){   
  if(isFmtWithZero)   
  return   (this<10?"0"+this:this);   
  else   return   this;   
  }   
  String.prototype.fmtWithZeroD   =   function(isFmtWithZero){   
  if(isFmtWithZero)   
  return   (this<10?"00"+this:(this<100?"0"+this:this));   
  else   return   this;   
  }   
    
  /*   ����   :   ������ĳ�������N��(N��24Сʱ)������   
    *   ����   :   num   number����   ����Ϊ�����������߸�����,Ĭ��Ϊ1;   
    *                 type   0(��)   or   1(��),Ĭ��Ϊ��   
    *   ����   :   �µ�PowerDate����   
    */   
  Date.prototype.dateAfter=function(num,type){   
  num   =   (num   ==   null?1:num);   
  if(typeof(num)!="number")   throw   new   Error(-1,"dateAfterDays(num,type)��num����Ϊ��ֵ����.");   
  type   =   (type==null?0:type);   
  var   arr   =   [1000,86400000];   
  var   dd   =   this.valueOf();   
  dd   +=   num*arr[type];   
  return   new   Date(dd);   
  }   
    
  //�ж��Ƿ�������,����true   ����   false   
  Date.prototype.isLeapYear   =   function   (){   
  var   year   =   this.getFullYear();   
  return   (0==year%4   &&   ((year   %   100   !=   0)||(year   %   400   ==   0)));   
  }   
    
  //���ظ�������   
  Date.prototype.getDaysOfMonth   =   function   (){   
  return   (new   Date(this.getFullYear(),this.getMonth()+1,0)).getDate();   
  }   
    
  //ת���ɴ�д����(����)   
  Date.prototype.getChinaDate   =     function(){   
  var   year   =   this.getFullYear().toString();   
  var   month=   this.getMonth()+1;   
  var   day   =   this.getDate();   
  var   arrNum   =   ["��","һ","��","��","��","��","��","��","��","��","ʮ","ʮһ","ʮ��"];   
  var   strTmp="";   
  for(var   i=0,j=year.length;i<j;i++){   
  strTmp   +=   arrNum[year.charAt(i)];   
  }   
  strTmp   +=   "��";   
  strTmp   +=   arrNum[month]+"��";   
  if(day<10)   
  strTmp   +=   arrNum[day];   
  else   if   (day   <20)   
  strTmp   +=   "ʮ"+arrNum[day-10];   
  else   if   (day   <30   )   
  strTmp   +=   "��ʮ"+arrNum[day-20];   
  else     
  strTmp   +=   "��ʮ"+arrNum[day-30];   
  strTmp   +=   "��";   
  return   strTmp;   
  }   
  //���ڱȽϺ���,����date:ΪDate����,��this�������ڲ���:1,���:0   ����:   -1   
  Date.prototype.dateCompare   =   function(date){   
  if(typeof(date)   !=   "object"   ||   !(/Date/.test(date.constructor)))   
    throw   new   Error(-1,"dateCompare(date)��date����ΪDate����.");   
  var   d   =   this.getTime()   -   date.getTime();   
  return   d>0?1:(d==0?0:-1);   
  }   
    
  /*����:����������֮��   
    *����:pd       PowerDate����   
    *         type:   ��������ʶ.yy:��,mm:��,ww:��,dd:��,hh:Сʱ,mi:��,ss:��,ms:����   
    *         intOrFloat   :�������ͻ��Ǹ�����ֵ   0:����,������0:������   
    *         output   :   �����ʾ,��:ʱ���Ϊ#��!   
    */   
  Date.prototype.calDateDistance   =   function   (date,type,intOrFloat,output){   
  if(typeof(date)   !=   "object"   ||   !(/Date/.test(date.constructor)))   
    throw   new   Error(-1,"calDateDistance(date,type,intOrFloat)��date����ΪDate����.");   
  type   =   (type==null?'dd':type);   
  if(!((new   RegExp(type+",","g")).test("yy,mm,ww,dd,hh,mi,ss,ms,")))   
    throw   new   Error(-1,"calDateDistance(pd,type,intOrFloat,output)��type����Ϊ�Ƿ�.");   
  var   iof   =   (intOrFloat==null?0:intOrFloat);   
  var   miSecMain   =   this.valueOf();   
  var   miSecSub     =   date.valueOf();   
  var   num=0;   
  switch(type){   
  case   "yy":   num   =   this.getFullYear()   -   date.getFullYear();   break;   
  case   "mm":   num   =   (this.getFullYear()   -   date.getFullYear())*12+this.getMonth()-date.getMonth();   break;   
  case   "ww":   num   =   ((miSecMain-miSecSub)/7/86400000).fmtRtnVal(iof);   break;   
  case   "dd":   num   =   ((miSecMain-miSecSub)/86400000).fmtRtnVal(iof);   break;   
  case   "hh":   num   =   ((miSecMain-miSecSub)/3600000).fmtRtnVal(iof);   break;   
  case   "mi":   num   =   ((miSecMain-miSecSub)/60000).fmtRtnVal(iof);   break;   
  case   "ss":   num   =   ((miSecMain-miSecSub)/1000).fmtRtnVal(iof);   break;   
  case   "ms":   num   =   (miSecMain-miSecSub);break;   
  default:     break;   
  }   
  if(output)   
  return   output.replace(/#/g,"   "+num+"   ");   
  else   return   num;   
  }   
  //��������������λС���ĸ�����   
  Number.prototype.fmtRtnVal   =   function   (intOrFloat){   
  return   (intOrFloat   ==   0   ?   Math.floor(this)   :   parseInt(this*100)/100);   
  }   

function isInteger( str ){ 
	var regu = /^[-]{0,1}[0-9]{1,}$/; 
	return regu.test(str); 
} 

	
function isNumber( s ){ 
	var regu = "^[0-9]+$"; 
	var re = new RegExp(regu); 
	if (s.search(re) != -1) { 
	return true; 
	} else { 
	return false; 
	} 
} 

function isDecimal( str ){ 
	if(isInteger(str)) return true; 
	var re = /^[-]{0,1}(\d+)[\.]+(\d+)$/; 
	if (re.test(str)) { 
	if(RegExp.$1==0&&RegExp.$2==0) return false; 
	return true; 
	} else { 
	return false; 
	} 
} 





function isNumeric(value,tLen , fLen){ 

	if(tLen <=fLen){
		return false;
	}
	
	
	if(! isDecimal(value)){
		return false;
	}
	value = value.replace(/\+|\-/ , "");

	if(isNumber(value)){
		if(value.length <= tLen){
			return true;
		}
	}
	
	if(value.replace(/\./ , "").length > tLen ) return false;
	
	var re = /^\d+(\.(\d*))?$/;
	var reg = new RegExp(re);
	
	if(reg.test(value)){
		if(RegExp.$2.length <=  fLen){
			return true;
		}
	}
	
	return false;

}


	function keyPressNumValidate(){
		if (getEvent().keyCode < 45 || event.keyCode > 57){
			getEvent().returnValue = false;
			return false;
		}
		return true;
	}
	
	//���re���ʽƥ�����ݵ��ַ���	
	function keyupNumValidate(re){
		var srcObj = getEvent().srcElement;
		if(srcObj && srcObj.type == 'text'){
			var text = srcObj.value;
			var reg = new RegExp(re );
			var had = false;
			while(reg.test(text)){
				had = true;
				text = text.replace(reg , "");
			}
			if(had){
				srcObj.value = text;	
			}
		}
		return true;
	}


/**
*	function:	Validate A Numeric is fix a format 
* 	author : 	Tony Chen
*/	
function validateNumeric(num,p,s){

		var intLen = p - s ;
		var aPos = num.indexOf(".");
		if(aPos == -1 ){
			
			if( num == 0 || num.length <= intLen ){
				return true;
			}
				
		}else{
			var intV = num.substr(0,aPos);
			var fIntLen = 0;
			if(parseInt(intV) > 0){
				fIntLen = intV.length;
			}

			if(fIntLen > intLen){
				return false;
			}
			
			var floatV = num.substr(aPos+1,num.length);
			var fFloatLen = floatV.length;
			
			if(fFloatLen > s){
				return false;
			}
			
			return true;
		}
		return false;
}


/**
*	function:	when key press validate numeric format 
* 	author : 	Tony Chen
*/
function NumericKeyPress(p,s){
	if(p == 0){
		return true;
	}
	if(p<s) return false;
	var intLen = p-s;
	var srcObj = event.srcElement ;
	var preValue = srcObj.value;
	var dotPos = preValue.indexOf(".");
	if((event.keyCode<48 || event.keyCode>57) && event.keyCode!=46 ){
		event.returnValue=false;
	}
	if(event.keyCode == 46){ // .
		if( s<=0 || dotPos != -1){
			event.returnValue=false;
			return false;
		}
		if(preValue ==""){
				srcObj.value = "0";
				return true;
		}
		
		
	}else{
		if(preValue == "0"){
			if(intLen > 0){
				srcObj.value ="";
				return true;
			}else{
				event.returnValue=false;
				return false;
			}
		}
		var afterValue = srcObj.value + (event.keyCode-48);
		
		if(validateNumeric(afterValue,p,s)){
			return true;	
		}else{
			event.returnValue=false;
			return false;
		}
	}
}

/**
*	function:	when key press validate negative numeric format
*   describe:   �������븺��
* 	author : 	Kylin
*/
function NegativeNumKeyPress(p,s){
	if(p == 0){
		return true;
	}
	if(p<s) return false;
	var intLen = p-s;
	var srcObj = event.srcElement ;
	var preValue = srcObj.value;
	var dotPos = preValue.indexOf(".");
	var negPos = preValue.indexOf("-");
	
	if((event.keyCode<48 || event.keyCode>57) && event.keyCode!=46 && event.keyCode!=45){
		event.returnValue=false;
	}

	if(event.keyCode == 46){ // .
		if( s<=0 || dotPos != -1){
			event.returnValue=false;
			return false;
		}
		if(preValue ==""){
				srcObj.value = "0";
				return true;
		}
		if(preValue =="-"){
				srcObj.value = "-0";
				return true;
		}
		
	}else if(event.keyCode == 45){
		if(negPos !=-1 || preValue.length !=0){
			event.returnValue=false;
			return false;	
		}
	}else{
		if(preValue == "0"){
			if(intLen > 0){
				srcObj.value ="";
				return true;
			}else{
				event.returnValue=false;
				return false;
			}
		}

		var afterValue = srcObj.value + (event.keyCode-48);
		afterValue = afterValue.replace(/\+|\-/ , "");
		if(validateNumeric(afterValue,p,s)){
			return true;	
		}else{
			event.returnValue=false;
			return false;
		}
	}
}

function NumericKeyUp(p,s){
	if(p == 0){
		return;
	}
	var intLen = p - s ;
	var re = /[^0-9\.]/;
	var srcObj = event.srcElement;
	if(srcObj && srcObj.type == 'text'){
		var text = srcObj.value;
		var reg = new RegExp(re );
		var changed = false;
		while(reg.test(text)){
			changed = true;
			text = text.replace(reg , "");
		}
		
		re = /^.*\..*(\.).*$/;
		reg = new RegExp(re );
		while(reg.test(text)){
			changed = true;
			text = text.replace(RegExp.$1 , "");
		}
		
		if(! validateNumeric(text,p,s)){
			
			if(text.indexOf(".") == -1){
					text = (parseInt(text) + "").substr(0,intLen);
			}else{
					var arr = text.split(".");
					if(arr.length >=2){
						
						var intValue = arr[0];
						if(intValue.length > intLen){
		
								intValue = intValue.substr(0,intLen);
						}
						var floatValue = arr[1];
						if(floatValue.length > s){
							floatValue = floatValue.substr(0,s);
						}
						text = intValue + "." + floatValue ;
				}
					
			}
			changed = true;
	}
		
		if(changed){
			srcObj.value = text;
			srcObj.select();	
		}
	}
	return true;
}

/**
*   describe:   �������븺��
* 	author : 	Kylin
*/
function NegativeNumericKeyUp(p,s){
	if(p == 0){
		return;
	}
	var intLen = p - s ;
	var re = /[^0-9\.\-]/;
	var srcObj = event.srcElement;
	if(srcObj && srcObj.type == 'text'){
		var text = srcObj.value;
		var reg = new RegExp(re );
		var changed = false;	
		var negFlg = false;	
		while(reg.test(text)){
			changed = true;
			text = text.replace(reg , "");
		}
		re = /^.*\..*(\.).*$/;
		reg = new RegExp(re );
		while(reg.test(text)){
			changed = true;
			text = text.replace(RegExp.$1 , "");
		}
		re = /^-/;
		reg = new RegExp(re );
		if(reg.test(text)){
			negFlg = true;
		}

		text = text.replace(/-/g, "");
		
		if(! validateNumeric(text,p,s)){
			if(text.indexOf(".") == -1){
					text = (parseInt(text) + "").substr(0,intLen);
			}else{
					var arr = text.split(".");
					if(arr.length >=2){
						
						var intValue = arr[0];
						if(intValue.length ==0){
							intValue = "0";
						}else if(intValue.length > intLen){
								intValue = intValue.substr(0,intLen);
						}
						if(negFlg)
							intValue="-"+intValue;
						var floatValue = arr[1];
						if(floatValue.length > s){
							floatValue = floatValue.substr(0,s);
						}
						if(floatValue.length == 0){
							text = intValue;
						}else{
							text = intValue + "." + floatValue ;
						}
				}
					
			}
			changed = true;
	}else{
		if(negFlg){
			srcObj.value = "-"+text;
		}else{
			srcObj.value = text;
		}
	}		
	if(changed){
		if(negFlg){	
			srcObj.value = "-"+text;
		}else{
			srcObj.value = text;
		}
		srcObj.select();	
		}
	}
	return true;
}

function NumericOnBlur(isPlus){
	var srcObj = getEvent().srcElement ;
	if(isPlus){
		if(parseFloat(srcObj.value) <= 0){
			srcObj.value = "";
			//alert(jsResources.system_value_much_be_plus);
			srcObj.select();
			return false;
		}
	}
	return true;
}

function getCurrencyFormat(s,num){
   if(/[^0-9\.]/.test(s)) return s;
   s=s.replace(/^(\d*)$/,"$1.");
   s=(s+"00").replace(/(\d*\.\d\d)\d*/,"$1");
   s=s.replace(".",",");
   var re=/(\d)(\d{3},)/;
   while(re.test(s))
           s=s.replace(re,"$1,$2");
   s=s.replace(/,(\d\d)$/,".$1");
   return s.replace(/^\./,"0.")
}

//ת���
function toDBCCase(str){
	var dbc = '';
	for(var i=0;i<str.length;i++){
		var c = str.charCodeAt(i);
		if(c >= 65281 && c <= 65373){
			dbc += String.fromCharCode(c-65248);
			}else if(c == 12288){
				dbc += String.fromCharCode(32);
				}else{
					dbc += str.charAt(i);
					}
		}
	return dbc;
	}
//add by james
function NegNumericKeyUp(p,s){
	if(p == 0){
		return;
	}
	var intLen = p - s ;
	var re = /[^0-9\.\-]/;
	var srcObj = event.srcElement;
	if(event.keyCode==37 || event.keyCode==39 || event.keyCode==8 || event.keyCode==46){
		event.returnValue=true;
		return true;
	}
	if(srcObj && srcObj.type == 'text'){
		var text = srcObj.value;
		var reg = new RegExp(re );
		var changed = false;	
		var negFlg = false;	
		while(reg.test(text)){
			changed = true;
			text = text.replace(reg , "");
		}
		re = /^.*\..*(\.).*$/;
		reg = new RegExp(re );
		while(reg.test(text)){
			changed = true;
			text = text.replace(RegExp.$1 , "");
		}
		re = /^-/;
		reg = new RegExp(re );
		if(reg.test(text)){
			negFlg = true;
		}

		text = text.replace(/-/g, "");
		if(negFlg)
			text='-'+text;
		if(! validateNumeric(text,p,s)){
			if(text.indexOf(".") == -1){
					text = (parseInt(text) + "").substr(0,intLen);
			}else{
					var arr = text.split(".");
					if(arr.length >=2){
						
						var intValue = arr[0];
						if(intValue.length ==0){
							intValue = "0";
						}else if(intValue.length > intLen){
								intValue = intValue.substr(0,intLen);
						}
						var floatValue = arr[1];
						if(floatValue.length > s){
							floatValue = floatValue.substr(0,s);
						}
						if(floatValue.length == 0){
							text = intValue;
						}else{
							text = intValue + "." + floatValue ;
						}
				}
			}
			changed = true;
	}else{
		srcObj.value = text;
	}		
	if(changed){
		srcObj.value = text;
		}
	}
	return true;
}
//add by james
function NegNumKeyPress(p,s){
	if(p == 0){
		return true;
	}
	if(p<s) return false;
	var intLen = p-s;
	var srcObj = event.srcElement ;
	var preValue = srcObj.value;
	var dotPos = preValue.indexOf(".");
	var negPos = preValue.indexOf("-");
	
	if((event.keyCode<48 || event.keyCode>57) && event.keyCode!=46 && event.keyCode!=45){
		event.returnValue=false;
	}

	if(event.keyCode == 46){ // .
		if( s<=0 || dotPos != -1){
			event.returnValue=false;
			return false;
		}
		if(preValue ==""){
				srcObj.value = "0";
				return true;
		}
		if(preValue =="-"){
				srcObj.value = "-0";
				return true;
		}
		
	}else if(event.keyCode == 45){
		if(negPos !=-1){
			event.returnValue=false;
			return false;	
		}
	}else{
		if(preValue == "0"){
			if(intLen > 0){
				srcObj.value ="";
				return true;
			}else{
				event.returnValue=false;
				return false;
			}
		}

		var afterValue = srcObj.value + (event.keyCode-48);
		afterValue = afterValue.replace(/\+|\-/ , "");
		if(validateNumeric(afterValue,p,s)){
			return true;	
		}else{
			event.returnValue=false;
			return false;
		}
	}
}

// ѡ��ȫ����ѡ��
function CheckAll(form)
{
for (var i=0;i<form.elements.length;i++){
var e = form.elements[i];
if (e.name != 'chkall')
	e.checked = form.chkall.checked;
	}
}