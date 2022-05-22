Setuppolices = function(data) {
    $(".polices-list").html("");
    var realestate = [];
    var mechanic = [];
    var taxi = [];
    var casino = [];
    var ambulance = [];
    var lawyer = [];
    var weazel = [];

    if (data.length > 0) {

        $.each(data, function(i, police) {
            if (police.typejob == "realstate") {
                realestate.push(police);
            }
            if (police.typejob == "lawyer") {
                lawyer.push(police);
            }
            if (police.typejob == "mechanic") {
                mechanic.push(police);
            }
            if (police.typejob == "taxi") {
                taxi.push(police);
            }
            if (police.typejob == "casino") {
                casino.push(police);
            }
            if (police.typejob == "ambulance") {
                ambulance.push(police);
            }
            if (police.typejob == "weazel") {
                weazel.push(police);
            }
        });

        $(".polices-list").append('<h1 style="font-size:1.641025641025641vh; padding:1.0256410256410255vh; color:#fff; margin-top:0; border-top-left-radius: .5vh; border-top-right-radius: .5vh; width:100%; display:block; background-color: rgb(127, 3, 252);">Casino (' + casino.length + ')</h1>');

        if (casino.length > 0) {
            $.each(casino, function(i, police) {
                var element = '<div class="police-list" id="policeid-' + i + '"> <div class="police-list-firstletter" style="background-color: rgb(127, 3, 252);">' + (police.name).charAt(0).toUpperCase() + '</div> <div class="police-list-fullname">' + police.name + '</div> <div class="police-list-call"><i class="fas fa-phone"></i></div> </div>'
                $(".polices-list").append(element);
                $("#policeid-" + i).data('policeData', police);
            });
        } else {
            var element = '<div class="police-list"><div class="no-polices">There are no Casino available.</div></div>'
            $(".polices-list").append(element);
        }

        $(".polices-list").append('<br><h1 style="font-size:1.641025641025641vh; padding:1.0256410256410255vh; color:#fff; margin-top:0; width:100%; display:block; background-color: rgb(43, 43, 43);">Lawyer (' + lawyer.length + ')</h1>');

        if (lawyer.length > 0) {
            $.each(lawyer, function(i, police1) {
                var element = '<div class="police-list" id="policeid1-' + i + '"> <div class="police-list-firstletter" style="background-color: rgb(43, 43, 43);">' + (police1.name).charAt(0).toUpperCase() + '</div> <div class="police-list-fullname">' + police1.name + '</div> <div class="police-list-call"><i class="fas fa-phone"></i></div> </div>'
                $(".polices-list").append(element);
                $("#policeid1-" + i).data('policeData', police1);
            });
        } else {
            var element = '<div class="police-list"><div class="no-polices">There are no Lawyer available.</div></div>'
            $(".polices-list").append(element);
        }

        $(".polices-list").append('<br><h1 style="font-size:1.641025641025641vh; padding:1.0256410256410255vh; color:#fff; margin-top:0; width:100%; display:block; background-color: rgb(255, 0, 0);">EMS (' + ambulance.length + ')</h1>');

        if (ambulance.length > 0) {
            $.each(ambulance, function(i, police2) {
                var element = '<div class="police-list" id="policeid2-' + i + '"> <div class="police-list-firstletter" style="background-color: rgb(255, 0, 0);">' + (police2.name).charAt(0).toUpperCase() + '</div> <div class="police-list-fullname">' + police2.name + '</div> <div class="police-list-call"><i class="fas fa-phone"></i></div> </div>'
                $(".polices-list").append(element);
                $("#policeid2-" + i).data('policeData', police2);
            });
        } else {
            var element = '<div class="police-list"><div class="no-polices">There are no EMS available.</div></div>'
            $(".polices-list").append(element);
        }

        $(".polices-list").append('<br><h1 style="font-size:1.641025641025641vh; padding:1.0256410256410255vh; color:#fff; margin-top:0; width:100%; display:block; background-color: rgb(255, 190, 27);">Taxi (' + taxi.length + ')</h1>');

        if (taxi.length > 0) {
            $.each(taxi, function(i, police3) {
                var element = '<div class="police-list" id="policeid3-' + i + '"> <div class="police-list-firstletter" style="background-color: rgb(255, 190, 27);">' + (police3.name).charAt(0).toUpperCase() + '</div> <div class="police-list-fullname">' + police3.name + '</div> <div class="police-list-call"><i class="fas fa-phone"></i></div> </div>'
                $(".polices-list").append(element);
                $("#policeid3-" + i).data('policeData', police3);
            });
        } else {
            var element = '<div class="police-list"><div class="no-polices">There are no taxis available.</div></div>'
            $(".polices-list").append(element);
        }
        
        $(".polices-list").append('<br><h1 style="font-size:1.641025641025641vh; padding:1.0256410256410255vh; color:#fff; margin-top:0; width:100%; display:block; background-color: rgb(255, 128, 0);">Mechanic (' + mechanic.length + ')</h1>');

        if (mechanic.length > 0) {
            $.each(mechanic, function(i, police4) {
                var element = '<div class="police-list" id="policeid4-' + i + '"> <div class="police-list-firstletter" style="background-color: rgb(255, 128, 0);">' + (police4.name).charAt(0).toUpperCase() + '</div> <div class="police-list-fullname">' + police4.name + '</div> <div class="police-list-call"><i class="fas fa-phone"></i></div> </div>'
                $(".polices-list").append(element);
                $("#policeid4-" + i).data('policeData', police4);
            });
        } else {
            var element = '<div class="police-list"><div class="no-polices">There is no Mechanic available.</div></div>'
            $(".polices-list").append(element);
        }
        
        $(".polices-list").append('<br><h1 style="font-size:1.641025641025641vh; padding:1.0256410256410255vh; color:#fff; margin-top:0; width:100%; display:block; background-color: rgb(0, 255, 0);">Real State (' + realestate.length + ')</h1>');

        if (realestate.length > 0) {
            $.each(realestate, function(i, police5) {
                var element = '<div class="police-list" id="policeid5-' + i + '"> <div class="police-list-firstletter" style="background-color: rgb(0, 255, 0);">' + (police5.name).charAt(0).toUpperCase() + '</div> <div class="police-list-fullname">' + police5.name + '</div> <div class="police-list-call"><i class="fas fa-phone"></i></div> </div>'
                $(".polices-list").append(element);
                $("#policeid5-" + i).data('policeData', police5);
            });
        } else {
            var element = '<div class="police-list"><div class="no-polices">There is no Real State available.</div></div>'
            $(".polices-list").append(element);
        }

        $(".polices-list").append('<br><h1 style="font-size:1.641025641025641vh; padding:1.0256410256410255vh; color:#fff; margin-top:0; width:100%; display:block; background-color: rgb(255, 0, 0);">News (' + weazel.length + ')</h1>');

        if (weazel.length > 0) {
            $.each(weazel, function(i, police6) {
                var element = '<div class="police-list" id="policeid6-' + i + '"> <div class="police-list-firstletter" style="background-color: rgb(255, 0, 0);">' + (police6.name).charAt(0).toUpperCase() + '</div> <div class="police-list-fullname">' + police6.name + '</div> <div class="police-list-call"><i class="fas fa-phone"></i></div> </div>'
                $(".polices-list").append(element);
                $("#policeid6-" + i).data('policeData', police6);
            });
        } else {
            var element = '<div class="police-list"><div class="no-polices">There is no News available.</div></div>'
            $(".polices-list").append(element);
        }
    } else {
        $(".polices-list").append('<h1 style="font-size:1.641025641025641vh; padding:1.0256410256410255vh; color:#fff; margin-top:0; border-top-left-radius: .5vh; border-top-right-radius: .5vh; width:100%; display:block; background-color: rgb(127, 3, 252);">Casino (' + casino.length + ')</h1>');

        var element = '<div class="police-list"><div class="no-polices">There are no Casino available.</div></div>'
        $(".polices-list").append(element);

        $(".polices-list").append('<br><h1 style="font-size:1.641025641025641vh; padding:1.0256410256410255vh; color:#fff; margin-top:0; width:100%; display:block; background-color: rgb(43, 43, 43);">Lawyer (' + lawyer.length + ')</h1>');

        var element = '<div class="police-list"><div class="no-polices">There are no Lawyer available.</div></div>'
        $(".polices-list").append(element);

        $(".polices-list").append('<br><h1 style="font-size:1.641025641025641vh; padding:1.0256410256410255vh; color:#fff; margin-top:0; width:100%; display:block; background-color: rgb(255, 0, 0);">EMS (' + ambulance.length + ')</h1>');

        var element = '<div class="police-list"><div class="no-polices">There are no EMS available.</div></div>'
        $(".polices-list").append(element);

        $(".polices-list").append('<br><h1 style="font-size:1.641025641025641vh; padding:1.0256410256410255vh; color:#fff; margin-top:0; width:100%; display:block; background-color: rgb(255, 190, 27);">Taxi (' + taxi.length + ')</h1>');

        var element = '<div class="police-list"><div class="no-polices">There are no taxis available.</div></div>'
        $(".polices-list").append(element);
        
        $(".polices-list").append('<br><h1 style="font-size:1.641025641025641vh; padding:1.0256410256410255vh; color:#fff; margin-top:0; width:100%; display:block; background-color: rgb(255, 128, 0);">Mechanic (' + mechanic.length + ')</h1>');

        var element = '<div class="police-list"><div class="no-polices">There are no Mechanic a available.</div></div>'
        $(".polices-list").append(element);
        
        $(".polices-list").append('<br><h1 style="font-size:1.641025641025641vh; padding:1.0256410256410255vh; color:#fff; margin-top:0; width:100%; display:block; background-color: rgb(0, 255, 0);">Real State (' + realestate.length + ')</h1>');

        var element = '<div class="police-list"><div class="no-polices">There are no Real State a available.</div></div>'
        $(".polices-list").append(element);

        $(".polices-list").append('<br><h1 style="font-size:1.641025641025641vh; padding:1.0256410256410255vh; color:#fff; margin-top:0; width:100%; display:block; background-color: rgb(255, 0, 0);">News (' + weazel.length + ')</h1>');

        var element = '<div class="police-list"><div class="no-polices">There are no News a available.</div></div>'
        $(".polices-list").append(element);
    }
}

$(document).on('click', '.police-list-call', function(e){
    e.preventDefault();

    var policeData = $(this).parent().data('policeData');
    
    var cData = {
        number: policeData.phone,
        name: policeData.name
    }

    $.post('https://PX_phone/CallContact', JSON.stringify({
        ContactData: cData,
        Anonymous: MI.Phone.Data.AnonymousCall,
    }), function(status){
        if (cData.number !== MI.Phone.Data.PlayerData.charinfo.phone) {
            if (status.IsOnline) {
                if (status.CanCall) {
                    if (!status.InCall) {
                        if (MI.Phone.Data.AnonymousCall) {
                            MI.Phone.Notifications.Add("fas fa-phone", "Phone", "You started a anonymous call!");
                        }
                        $(".phone-call-outgoing").css({"display":"block"});
                        $(".phone-call-incoming").css({"display":"none"});
                        $(".phone-call-ongoing").css({"display":"none"});
                        $(".phone-call-outgoing-caller").html(cData.name);
                        MI.Phone.Functions.HeaderTextColor("white", 400);
                        MI.Phone.Animations.TopSlideUp('.phone-application-container', 400, -160);
                        setTimeout(function(){
                            $(".polices-app").css({"display":"none"});
                            MI.Phone.Animations.TopSlideDown('.phone-application-container', 400, 0);
                            MI.Phone.Functions.ToggleApp("phone-call", "block");
                        }, 450);
    
                        CallData.name = cData.name;
                        CallData.number = cData.number;
                    
                        MI.Phone.Data.currentApplication = "phone-call";
                    } else {
                        MI.Phone.Notifications.Add("fas fa-phone", "Phone", "You are already connected to a call!");
                    }
                } else {
                    MI.Phone.Notifications.Add("fas fa-phone", "Phone", "This person is already in a call");
                }
            } else {
                MI.Phone.Notifications.Add("fas fa-phone", "Phone", "This person is not available!");
            }
        } else {
            MI.Phone.Notifications.Add("fas fa-phone", "Phone", "You can't call your own number!");
        }
    });
});