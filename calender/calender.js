change_price=function(ele)
{
	alert("change_price!");
	var p_input=ele.parentElement.parentElement.nextSibling.nextSibling;
	p_input.value=ele.innerHTML;
	var parent=ele.parentElement.parentElement;
	parent.style.display='none';
	p_input.style.display='block';
	p_input.focus();
	//p_input.onblur=price_confirm(p_input);
}
price_confirm=function(ele)
{
	var price=ele.value;
	ele.style.display='none';
	var price_div=ele.previousSibling.previousSibling;
	if(price)
	{
		price_div.firstChild.nextSibling.nextSibling.nextSibling.firstChild.innerHTML=price;
	}
	//alert(ele.id);
	price_div.style.display='block';
	
}
change_price_commit=function(product_id,date,index,description)
{
	//alert(date);
	var price;
	price = document.getElementById(index).value;
	var   r   =   /^[0-9]*[1-9][0-9]*$/　　//正整数    
	if(!r.test(price)){
	alert("价格必须为正整数");
	return;
	}
	if(description)description='&description='+description
	Ajax({
		url:'/ajax/modifySpecialPrice.asp',
		data:'product_id='+product_id+'&date='+date+'&price='+price+description,
		onSuccess:function(e){alert(e)}
	})
}
change_normalprice_commit=function(product_id,index)
{
	
	var price;
	if(index==1){
	price = document.getElementById("dayrentprice").value;
	}else{
	price = document.getElementById("weekrentprice").value;
	}
	//alert(price);
	var   r   =   /^[0-9]*[1-9][0-9]*$/　　//正整数    
	if(!r.test(price)){
	alert("价格必须为正整数");
	return;
	}
	
	Ajax({
		url:'/ajax/modifyNormalPrice.asp',
		data:'product_id='+product_id+'&price='+price+'&priceType='+index,
		onSuccess:function(e){alert(e);
		                      location.reload();}
	})
}