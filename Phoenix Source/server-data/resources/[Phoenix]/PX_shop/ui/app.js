let template = '';
$(document).ready(function () {
    template = $('#item-template').html();
    $('#item-template').remove();
});

let shopNumber = 0;
$(function () {
    window.addEventListener('message', function (event) {
        if (event.data.type === "open") {
            $('.auto-insurance').fadeIn();
            shopNumber = event.data.data.shop;
            $('.shopNumber').text(shopNumber);
            loadShit(event.data.data.inventory);
        }
    });
});
function loadShit(items) {
    $("#carsConteiner").html('');
    items.forEach((item) => {
        $("#carsConteiner").append(Mustache.render(template, item));
    });
}
function buyItem(name,quantity) {
    if(isNaN(parseInt(quantity))) quantity = 1;
    var obj = { name: name, count: quantity, shop: shopNumber };
    $.post("http://PX_shop/purchase", JSON.stringify(obj), function () { });
}
function Exit() {
    $('.auto-insurance').fadeOut();
    $.post("http://PX_shop/close", true, function () { });
}