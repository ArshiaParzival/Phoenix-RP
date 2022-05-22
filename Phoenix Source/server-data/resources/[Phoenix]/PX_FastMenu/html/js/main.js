'use strict';

var QBRadialMenu = null;

$(document).ready(function(){

    window.addEventListener('message', function(event){
        var eventData = event.data;

        if (eventData.action == "ui") {
            if (eventData.radial) {
                createMenu(eventData.items)
                QBRadialMenu.open();
            } else {
                QBRadialMenu.close();
            }
        }

        if (eventData.action == "setPlayers") {
            createMenu(eventData.items)
        }
    });
});

function createMenu(items) {
    QBRadialMenu = new RadialMenu({
        parent      : document.body,
        size        : 375,
        menuItems   : items,
        onClick     : function(item) {
            if (item.shouldClose) {
                QBRadialMenu.close();
            }
            
            if (item.event !== null) {
                if (item.data !== null) {
                    $.post('http://PX_FastMenu/selectItem', JSON.stringify({
                        itemData: item,
                        data: item.data
                    }))
                } else {
                    $.post('http://PX_FastMenu/selectItem', JSON.stringify({
                        itemData: item
                    }))
                }
            }
        }
    });
}

$(document).on('keydown', function() {
    switch(event.keyCode) {
        case 35: // ESC
            QBRadialMenu.close();
            break;
    }
});

window.addEventListener('message', (event) => {
if (event.data.action=="copy"){
    copy(event.data.cdata)
}
})

function copy(text) {
    var input = document.createElement('input');
    input.setAttribute('value', text);
    document.body.appendChild(input);
    input.select();
    var result = document.execCommand('copy');
    document.body.removeChild(input);
    return result;
 }