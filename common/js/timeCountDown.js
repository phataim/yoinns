var SysSecond;   
var InterValObj;   
var arr = new Array();
 
var parseStr = "";

    
 $(document).ready(function() {   
	parseStr = $("#remainSeconds").html(); //这里获取倒计时的起始时间   
	var arr1 = parseStr.split(":")
	for(var i = 0;i < arr1.length;i ++){
		arr[i] = arr1[i].split(",")
	}
	SetRemainTime();
    InterValObj = window.setInterval(SetRemainTime, 1000); //间隔函数，1秒执行   
 });   
  
 //将时间减去1秒，计算天、时、分、秒   
 function SetRemainTime() {   
 	for(var i = 0;i < arr.length;i ++){
		if (arr[i][1] > 0) {   
		   arr[i][1] = arr[i][1] - 1;   
		   var second = Math.floor(arr[i][1] % 60);             // 计算秒       
		   var minite = Math.floor((arr[i][1] / 60) % 60);      //计算分   
		   var hour = Math.floor((arr[i][1] / 3600) % 24);      //计算小时   
		   var day = Math.floor((arr[i][1] / 3600) / 24);        //计算天   
		  
		   //$("#remainTime_"+ arr[i][0]).html(day + "天" + hour + "小时" + minite + "分" + second + "秒");  
		   $("#remainTime_"+ arr[i][0]).html("<span class='item'><span class='day_num'>"+day+"</span>天</span><span class='item'><span class='hour_num'>"+hour+"</span>小时</span><span class='item'><span class='minute_num'>"+minite+"</span>分</span><span class='item'><span class='second_num'>"+second+"</span>秒</span>");  
							
		  } else {//剩余时间小于或等于0的时候，就停止间隔函数   
		   window.clearInterval(InterValObj);   
		   //这里可以添加倒计时时间为0后需要执行的事件   
		  }   
	}
 } 