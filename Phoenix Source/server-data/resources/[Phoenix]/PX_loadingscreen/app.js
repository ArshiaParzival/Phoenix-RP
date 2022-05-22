Init();

function Init(){
	BoxColorAsWaweAndTXT();
	VersionLogo();
	BackGroundType();
	Lang();
}

function Lang(){
	$('#txt-load').html(TXT_Load);
	$('#txt-play').html(TXT_Player);
}

function BackGroundType(){
	if(!UseVideo){
		  $('#videobg').hide();
		  $('#bg').hide();	
	   } else {
		  document.getElementById('videobg').play();
		  $('#bg_alt').hide();
	   }
}

function VersionLogo(){
	if(version == 1){	
	   setToCenterOfParent( $('#logo'), $('#bg'), false, false);
	   document.getElementById("discord").innerHTML = '<b>' + Discord + '</b>';	
	   $('#logo-alt').hide();

	} else {
	   $('#logo').hide();
	}
	
}

function BoxColorAsWaweAndTXT(){
	//box
	$("#fix_box").css("color", ColorTXT);
	$("#fix_box").css("border", '2px solid ' + ColorTXT);
	$("#fix_box1").css("color", ColorTXT);
	$("#fix_box1").css("border", '2px solid ' + ColorTXT);
	//txt
	$("#spinner").css("--border-color", 'transparent transparent ' + ColorTXT + ' ' + ColorTXT);
	$("#loading-text").css("color", ColorTXT);
	
}

function setToCenterOfParent(box, screen, ignoreWidth, ignoreHeight){
        parentWidth = $(screen).width();
        parentHeight = $(screen).height();  
        elementWidth = $(box).width();
        elementHeight = $(box).height();
				
        if(!ignoreWidth)
            $(box).css('left', ((parentWidth/2) - (elementWidth/2)) );
        if(!ignoreHeight)
            $(box).css('top', ((parentHeight/2) - (elementHeight/2)) );
}