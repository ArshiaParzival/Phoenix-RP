let playTime = 0;
setInterval(() => {
    playTime+= 60;
    $('.box3-pt .count div').text(calculateJoinedTime(playTime));
}, 60000);
$(document).ready(function () {
    window.addEventListener('message', function (event) {
        if (event.data.type == 'toggle') {
            if (event.data.action) {
                $('.main').addClass('open');
            } else {
                $('.main').removeClass('open');
            }
        } else if (event.data.type == 'updateInfo') {
            let dt = event.data.data;
            $('.box-admins .count div').text(dt.admins);
            $('.box2-players .count div').text(dt.players);
        }
    });
});
function calculateJoinedTime(d) {
    d = Number(d);
    var h = Math.floor(d / 3600);
    var m = Math.floor(d % 3600 / 60);
    return `${h.toString().padStart(2, 0)}:${m.toString().padStart(2, 0)}`;
}