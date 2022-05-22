window.onload = (e) => {
  window.addEventListener('message', onMessageRecieved);
};

function onMessageRecieved(event){
  let item = event.data;
  if (!item) return
  if (item.type === 'streetLabel:MSG') {
    if (!item.active) {
      $("#container").hide();
    } else {
      $("#container").show();
      
      let direction = item.direction;
      let zone = item.zone;
      let street = item.street;
      let timestamp = item.time;
      
      $('#timestamp').text(timestamp);
      $('#direction').text(direction);
      $('#zone').text(zone);
      $('#street').text(street);
      if(item.ncz) {
        if($('#street .blue')) { $('#street .blue').remove(); }
        $('#street').html(`<div class="blue">[NCZ]</div>`+$('#street').html());
      } else {
        if($('#street .blue')) {
          $('#street .blue').remove();
        }
      }
    }
  } else if (item.type == "displayaddress") {
    let direction = item.direction;
    let zone = item.zone;
    let street = item.street;
    let timestamp = item.time;
    $('#timestamp').text(timestamp);
    $('#direction').text(direction);
    $('#zone').text(zone);
    $('#street').text(street);
    if (!item.active) {
      $('.directionHolder').hide();
      $('.addressHolder').hide();
    } else {
      $('.directionHolder').show();
      $('.addressHolder').show();
    }
  }
  if(item.action == 'minimap') {
    $('#container').css('left',item.data.x+330);
  }
}
