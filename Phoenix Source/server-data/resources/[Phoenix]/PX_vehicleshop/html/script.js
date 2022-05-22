var categoryVehicleSelected = "all";
var vehicleSelected = {};
var isEnableTestDrive = false;

var dataVehicles = []
var handlingVehicle = [];

var selectedColor = "primary";



window.addEventListener('message', function(event) {
    var data = event.data;

    if (event.data.type == "display") {
        pickr.hide();
        $("body").fadeIn();

        isEnableTestDrive = event.data.testDrive;

        document.getElementById("top-menu").innerHTML = '<a href="#all" onclick="menuVehicle(event)" value="all" class="selected">all</a>';

        for (var [key, value] of Object.entries(data.data)) {

            $('.top-menu').append(`
                <a href="#` + key + `" onclick="menuVehicle(event)" value="` + key + `">` + key + `</a>            
            `);

            for (var [k, v] of Object.entries(value)) {
                dataVehicles.push(v);
            }
        }
        Dealership.Open(dataVehicles);

        //  document.getElementById("playerName").innerHTML = data.playerName;        
        //  document.getElementById("playerMoney").innerHTML = data.playerMoney;
    }

    if (event.data.type == "hide") {
        $("body").fadeOut();
    }

    if (event.data.type == "menu") {

        for (var [k, v] of Object.entries(data.data)) {
            dataVehicles.push(v);
        }
        Dealership.Open(dataVehicles);
    }

    if (event.data.type == "updateVehicleInfos") {
        var data = event.data;
        handlingVehicle = data.data;

        $('.middle-right-container').show();
        $('#contentVehicle').append(`
                    <div class="row spacebetween">
                        <span class="priceVehicle">` + (event.data.vehiclemodel).toUpperCase() + `</span>
                    </div>

                    <div class="column spacebetween info">
                        <span class="title">Power</span>
                        <div class="bar">
                            <span class="percent trac" style="width:` + Math.ceil(10 * handlingVehicle.traction * 1.6) + `%"></span>
                            <div class="percent-yazi">` + (handlingVehicle.traction / 1).toFixed(1) + `</div>
                        </div>
                     
                    </div>

                    <div class="column spacebetween info">
                        <span class="title">HIGH SPEED</span>
                        <div class="bar">
                            <span class="percent maxs" style="width:` + Math.ceil(handlingVehicle.maxSpeed * 1.4) + `%"></span>
                            <div class="percent-yazi">` + (handlingVehicle.maxSpeed / 10).toFixed(1) + `</div>
                        </div>

                    </div>

                    <div class="column spacebetween info">
                        <span class="title">ACCELERATION</span>
                        <div class="bar">
                            <span class="percent acce" style="width:` + Math.ceil(100 * handlingVehicle.acceleration) + `%"></span>
                            <div class="percent-yazi">` + handlingVehicle.acceleration.toFixed(1) + `</div>
                        </div>
                    </div>

                    <div class="column spacebetween info">
                        <span class="title">Brake</span>
                        <div class="bar">
                            <span class="percent brea" style="width:` + Math.ceil(100 * handlingVehicle.breaking) + `%"></span>
                            <div class="percent-yazi">` + handlingVehicle.breaking.toFixed(1) + `</div>
                        </div>
                    </div>
                `);
        $('.trac').animate({ width: Math.ceil(10 * handlingVehicle.traction * 1.6) }, { queue: false, duration: 100 })
        $('.maxs').animate({ width: Math.ceil(handlingVehicle.maxSpeed * 1.4) }, { queue: false, duration: 100 })
        $('.acce').animate({ width: Math.ceil(handlingVehicle.acceleration * 100) }, { queue: false, duration: 100 })
        $('.brea').animate({ width: Math.ceil(100 * handlingVehicle.breaking) }, { queue: false, duration: 100 })
    }

    if (event.data.type == "updateMoney") {
        document.getElementById("playerMoney").innerHTML = data.playerMoney;
    }

});

$(document).ready(function() {
    $('.upper-bottom-container').on('afterChange', function(event, slick, currentSlide) {

        $('.button-container').appendTo(currentSlide);
    });
});

function menuVehicle(event) {
    var div = $(event.target).parent().find('.selected');

    $(div).removeClass('selected');

    $(event.currentTarget).addClass('selected');

    categoryVehicleSelected = $(event.currentTarget).attr('value');

    document.getElementById("nameBrand").innerHTML = '';
    document.getElementById("contentVehicle").innerHTML = '';
    document.getElementById("vehiclebrand").innerHTML = '';
    document.getElementById("carouselCars").innerHTML = '';

    dataVehicles = []

    $.post('https://PX_vehicleshop/menuSelected', JSON.stringify({ menuId: categoryVehicleSelected.toLowerCase() }));
    $('.middle-right-container').hide();
    $(".getSpacebuet").hide();
}

function testDrive() {
    $.post('https://PX_vehicleshop/TestDrive', JSON.stringify({ vehicleModel: vehicleSelected.modelcar }));
    $('body').css("display", "none");
}



function openModalMenu() {
    document.getElementById("closemenu").innerHTML = '';
    $("body").fadeIn();
    $('.modal').css("display", "flex");

    $('#closemenu').append(`
        <div class="modal-footer">
            <div class="modal-price">
            <p class='arac-siktim-oldu'>DO YOU WANT TO BUY IT NOW ?</p>  
            <p class='arac-siktim'>` + (vehicleSelected.modelcar).toUpperCase() + `</p>  
                <p class='price-sale'>$ ` + vehicleSelected.sale + `,000</p>         
            </div>
        </div>
        <button id="money" class="evet-siktim-menu" onclick="buyVehicle('confirm')" >YES</button>
        <button href="#!" id="card" class="hayir-siktim-menu" onclick="buyVehicle('cancel')">NO</button>
    `);
}

function openModalMenuG() {
    document.getElementById("closemenu").innerHTML = '';
    $("body").fadeIn();
    $('.modal').css("display", "flex");

    $('#closemenu').append(`
        <div class="modal-footer">
            <div class="modal-price">
            <p class='arac-siktim-oldu'>DO YOU WANT TO BUY IT NOW ?</p>  
            <p class='arac-siktim'>` + (vehicleSelected.modelcar).toUpperCase() + `</p>  
                <p class='price-sale'>$ ` + vehicleSelected.sale + `,000</p>         
            </div>
        </div>
        <button id="money" class="evet-siktim-menu" onclick="buyVehicleG('confirm')" >YES</button>
        <button href="#!" id="card" class="hayir-siktim-menu" onclick="buyVehicleG('cancel')">NO</button>
    `);
}


function buyVehicle(option) {
    $('.modal').css("display", "none");


    switch (option) {
        case 'cancel':
            break;
        case 'confirm':
            $.post('https://PX_vehicleshop/Buy', JSON.stringify(vehicleSelected));
            break;
    }
}

function buyVehicleG(option) {
    $('.modal').css("display", "none");


    switch (option) {
        case 'cancel':
            break;
        case 'confirm':
            $.post('https://PX_vehicleshop/BuyGang', JSON.stringify(vehicleSelected));
            break;
    }
}



var scrollAmount = 0

$(document).on('keydown', function() {
    switch (event.keyCode) {
        case 27: // ESC
            $.post('https://PX_vehicleshop/Close');
            $('body').css("display", "none");
            document.getElementById("top-menu").innerHTML = '';
            break;
        case 9: // TAB
            break;
        case 17: // TAB
            break;
        case 68: // LEFT A
            $.post('https://PX_vehicleshop/rotate', JSON.stringify({ key: "left" }))
            break;
        case 65: // RIGHT D
            $.post('https://PX_vehicleshop/rotate', JSON.stringify({ key: "right" }))
            break;
        case 39:
            scrollAmount = scrollAmount + 300
            $('.carousel-cars').animate({ scrollLeft: scrollAmount }, 'fast');
            // seta direita
            break;
        case 37:
            scrollAmount = scrollAmount - 300
            $('.carousel-cars').animate({ scrollLeft: scrollAmount }, 'fast');
            // seta esquerda
            break;
    }
});


$(document).on('keydown', function(ev) {
    var input = $(ev.target);
    var num = input.hasClass('input-number');
    var _key = false;
    if (ev.which == 68) {
        if (num === false) {
            _key = "left"
        } else if (num) {
            input.val(parseInt(input.val()) + 1)
            inputChange(input, true)
        }
    }
    if (ev.which == 65) {
        if (num === false) {
            _key = "right"
        } else if (num) {
            input.val(parseInt(input.val()) - 1)
            inputChange(input, false)
        }
    }

    if (_key) {
        $.post('https://PX_vehicleshop/rotate', JSON.stringify({ key: _key }))
    }

});


$(document).on('mousedown', ".item-cars", function(event) {

    switch (event.which) {
        case 3:
            // click direito

            break;
        case 1:
            // click esquerdo

            var div = $(this).parent().find('.selectedVehicle');
            $(div).removeClass('selectedVehicle');

            var classList = $(event.currentTarget).attr('class').split(/\s+/);
            var itemDisabled = false;

            $.each(classList, function(index, item) {
                if (item === 'disable') {
                    itemDisabled = true;
                }
            });

            if (!itemDisabled) {
                $(event.currentTarget).addClass('selectedVehicle');

                $('#colorPicker').css("display", "flex");

                var dataCar = $(event.currentTarget).find('.specification').find('span');

                var scroll = $(event.currentTarget).position();



                if (scroll.left > 500) {
                    scrollAmount = scrollAmount + scroll.left
                } else if (scroll.left < 0) {
                    scrollAmount = scrollAmount - scrollAmount / 2 + scroll.left
                } else {
                    scrollAmount = scrollAmount - scroll.left
                }

                $('.carousel-cars').animate({ scrollLeft: scrollAmount }, 'fast');

                $('.modal').css("display", "none");

                document.getElementById("nameBrand").innerHTML = '';
                document.getElementById("vehiclebrand").innerHTML = '';
                document.getElementById("contentVehicle").innerHTML = '';

                $(".getSpacebuet").css("display", "block");

                vehicleSelected = { brand: dataCar[0].outerText, modelcar: dataCar[9].outerText, sale: dataCar[7].outerText / 1000, name: dataCar[1].outerText }
                $.post("https://PX_vehicleshop/SpawnVehicle", JSON.stringify({ modelcar: dataCar[9].outerText, price: dataCar[7].outerText }));
            }
            break;
    }
});

(() => {
    Dealership = {};



    Dealership.Open = function(data) {
        for (i = 0; i < (data.length); i++) {

            var modelUper = data[i].model;
            // priceb = data[i].price * 100
            var priceVehicle = data[i].price.toLocaleString('pt-br');

            if (data[i].qtd < 1) {
                $(".carousel-cars").append(`
                <div class="item-cars"> 
                    <div class="col-lg-3 col-md-6 "> 
                        <div class="specification" style="opacity:0.0; position:absolute;">
                            <span id="brand">` + data[i].brand + `</span>
                            <span id="name">` + data[i].name + `</span>
                            <span id="fabrication">` + data[i].fabrication + `</span>
                            <span id="handling">` + data[i].handling + `</span>
                            <span id="topspeed">` + data[i].topspeed + `</span>
                            <span id="power">` + data[i].power + `</span>
                            <span id="breaking">` + data[i].breaking + `</span>
                            <span id="price">` + data[i].price + `</span>
                            <span id="qtd">` + data[i].qtd + `</span>
                            <span id="model">` + data[i].model + `</span>
                            <span id="category">` + data[i].category + `</span>
                        </div> 
                        <div class="price">NO STOCK</div>                 
                        <div class="img-fluid" style="background-image: url(../imgs/` + modelUper.toUpperCase() + `.png);"></div>
                    </div>
                </div>`);
            } else if (data[i].qtd > 0) {
                $(".carousel-cars").append(`
                <div class="item-cars" >
                    <div class="col-lg-3 col-md-6 ">
                        <div class="specification" style="opacity:0.0; position:absolute;">
                            <span id="brand">` + data[i].brand + `</span>
                            <span id="name">` + data[i].name + `</span>
                            <span id="fabrication">` + data[i].fabrication + `</span>
                            <span id="handling">` + data[i].handling + `</span>
                            <span id="topspeed">` + data[i].topspeed + `</span>
                            <span id="power">` + data[i].power + `</span>
                            <span id="breaking">` + data[i].breaking + `</span>
                            <span id="price">` + data[i].price + `</span>
                            <span id="qtd">` + data[i].qtd + `</span>
                            <span id="model">` + data[i].model + `</span>
                            <span id="category">` + data[i].category + `</span>
      
                        </div>
                        <div class="price">$` + priceVehicle + `</div>  
                        <div class="img-fluid" style="background-image:  url(../imgs/` + modelUper.toUpperCase() + `.png);"></div>
                    </div>
                </div>`);
            }
        }
    }
    Dealership.Open(dataVehicles)
})();



function openOption(option) {
    pickr.show();
}


function setVehicleColorRGB(R, G, B) {
    if (selectedColor == 'primary') {
        $.post("https://PX_vehicleshop/RGBVehicle", JSON.stringify({ primary: true, R: R, G: G, B: B }));
    } else {
        $.post("https://PX_vehicleshop/RGBVehicle", JSON.stringify({ primary: false, R: R, G: G, B: B }));
    }
}