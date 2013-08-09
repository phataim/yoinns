
var t = m = count = 0;   
var timeInterval = 2500;
$(function(){   
    count = $("#pic_container .picture").size();   
    $("#pic_container .picture:not(:first-child)").hide();   
    $('.prev').bind("click",function(){
        m = m<= 0 ? (count-1) : m-1;
        change_pic();
        clearInterval(t);
        if($('.picture_page').children().eq(1).attr('class').indexOf('play') == -1)
        {
            t = setInterval("showAuto()",timeInterval);   
        }
    });
    $('.next').bind("click",function(){ 
        m = m>= (count-1) ? 0 : m+1;
        change_pic();
        clearInterval(t);
        if($('.picture_page').children().eq(1).attr('class').indexOf('play') == -1)
        {
            t = setInterval("showAuto()",timeInterval);   
        }
    });
    t = setInterval("showAuto()",timeInterval);   
    
})
function change_pic()
{
    $('#pic_container').children().eq(m).ready(function()
            {
               // $("#pic_container").children().eq(m).css('left',$("#pic_container .picture").filter(":visible").offset().left);
               // $("#pic_container").children().eq(m).css('top',$("#pic_container .picture").filter(":visible").offset().top);
                $("#pic_container .picture").filter(":visible").fadeOut(800).parent().children().eq(m).fadeIn(900);   
                loadNxtPicUrl();
                loadPrePicUrl();

            }); 
}
function loadNxtPicUrl()
{
    var chang2N = getNextNum(m);
    setBlankImgUrl(chang2N);
}

function loadPrePicUrl()
{
    var chang2N = getPreNum(m);
    setBlankImgUrl(chang2N);
}

function setBlankImgUrl(chang2N)
{
    if($("#idxRoomPic"+chang2N).attr("src") =='about:blank')
    {
        $("#idxRoomPic"+chang2N).attr("src",idxRecommend[chang2N].mainimageurl);
        $("#idxUserPic"+chang2N).attr("src",idxRecommend[chang2N].landlordheadimage);
    }
}

function getPreNum(cur)
{
    var pCount = $("#pic_container .picture").size();
    var preP;
    preP = cur<=0 ?(pCount-1):cur-1;
    return  preP;
}
function getNextNum(cur)
{
    var pCount = $("#pic_container .picture").size();
    var nextP;
    nextP = cur>= (pCount-1) ? 0 : cur+1;
    return  nextP;
}
    
function showAuto()   
{   
    m= m >= (count - 1) ? 0 : m + 1;   
    change_pic();
}
$('#pic_container').mouseover(function()
{
    $('.picture_page').show();
})
$('#pic_container').mouseout(function()
{
    $('.picture_page').hide();
})
$('.picture_page').children().eq(1).mouseover(function()
{
   var middleClass = $(this).attr('class');  
   $(this).removeClass(middleClass);
   $(this).addClass(middleClass+'selected');
});
$('.picture_page').children().eq(1).mouseout(function()
{
   var middleClass = $(this).attr('class');  
   var middleClass_new = middleClass.replace('selected','');
   $(this).removeClass(middleClass);
   $(this).addClass(middleClass_new);
});
$('.picture_page').children().eq(1).click(function()
{
   var middleClass = $(this).attr('class');
   if(middleClass.indexOf('play') >= 0)
   {
        $(this).removeClass(middleClass);
        $(this).addClass('middle_stopselected'); 
        t=setInterval("showAuto()",6000)
   }else
  {
        $(this).removeClass(middleClass);
        $(this).addClass('middle_playselected'); 
        clearInterval(t);
  }
});