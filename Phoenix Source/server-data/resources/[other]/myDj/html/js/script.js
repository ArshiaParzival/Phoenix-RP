$(document).ready(function() {
    $('body').hide()

    // .click(function() {
    //     return;
    // });

    var btn = $(".PlayButton");
    var PlayButton = $("#buttonOne");
    var directPlay = $('#directPlay');
    var currentSongLabel = '';
    var buttonTwo = $('#buttonTwo');
    var buttonThree = $('#buttonThree');
    var buttonFour = $('#buttonFour');
    var buttonFive = $('#buttonFive');
    var buttonSix = $('#buttonSix');
    var buttonSeven = $('#buttonSeven');
    var addToPlaylist = $('#addToPlaylist');
    var HighestPlayListId = 0
    var isDropDownOpen = false
    var perc = 0

    btn.click(function() {
        $.post('http://myDj/togglePlaystate', JSON.stringify({}));
        btn.toggleClass("paused");
        PlayButton.toggleClass("paused2")
        return false;
    });

    PlayButton.click(function() {
        $.post('http://myDj/togglePlaystate', JSON.stringify({}));
        btn.toggleClass("paused");
        PlayButton.toggleClass("paused2")
        return false;
    });

    directPlay.click(function() {
        $.post('http://myDj/playNewSong', JSON.stringify({
            link: $('#linkInput').val()
        }));
        return;
    });

    buttonTwo.click(function() {
        $.post('http://myDj/rewind', JSON.stringify({}));
        $('#timeLineInside').width($('#timeLineInside').width()-(perc*10))
        return;
    });

    buttonThree.click(function() {
        $.post('http://myDj/forward', JSON.stringify({}));
        $('#timeLineInside').width($('#timeLineInside').width()+(perc*10))
        return;
    });

    buttonFour.click(function() {
        $.post('http://myDj/down', JSON.stringify({}));
        return;
    });

    buttonFive.click(function() {
        $.post('http://myDj/up', JSON.stringify({}));
        return;
    });

    var AddPlaylist = $('#PlayListAddButton');
    AddPlaylist.click(function() {
        // console.log($('#CreatePlaylistName').val())
        if ($('#CreatePlaylistName').val() != '') {
            var newHtml = $('#playlists').html()
            // console.log(HighestPlayListId + ' ' + $('#CreatePlaylistName').val())
            newHtml += `
            <div class="playlist" data-id="${HighestPlayListId}">
                <button id="playlist${HighestPlayListId}" class="playlistButton">${$('#CreatePlaylistName').val()}</button>
                <div id="songSpace${HighestPlayListId} class="songs" data-id="${HighestPlayListId}" data-displayed="0"></div>
            </div>`
            $('#playlists').html(newHtml)
            $.post('http://myDj/addPlayList', JSON.stringify({
                id: HighestPlayListId,
                name: $('#CreatePlaylistName').val()
            }));
            var newHtml = $('#addPlaylist').html()
            newHtml += `<p class="addPlaylistButton" data-id="${HighestPlayListId}">${$('#CreatePlaylistName').val()}</p>`
            $('#addPlaylist').html(newHtml)
        }

        return;
    });

    addToPlaylist.click(function() {
        
        var addPlaylist = $('#addPlaylist')
        if (isDropDownOpen) {
            isDropDownOpen = false
            addPlaylist.animate({height: '0', width: '0'});
            setTimeout(function() {
                addPlaylist.css('display', 'none');
            }, 350);
        } else {
            console.log('Dropdown open')
            isDropDownOpen = true
            addPlaylist.css('display', 'block');
            addPlaylist.animate({height: '100%', width: '100%'});
        }
        return;
    });

    $(document).on('click', '.deleteSongs', function() {
        console.log($(this).parent().data('songid') + ' ' + $(this).parent().data('link') + ' ' + $(this).parent().parent().data('id'))
        $.post('http://myDj/deleteSong', JSON.stringify({
            id: $(this).parent().data('songid'),
            playlistId: $(this).parent().parent().data('id')
        }));
        $(this).parent().remove()
    });

    $(document).on('click', '.deletePlaylist', function() {
        // console.log($(this).parent().parent().data('id'))
        $.post('http://myDj/deletePlaylist', JSON.stringify({
            id: $(this).parent().parent().data('id'),
        }));
        if (PlaylistIsVisible) {
            songs.remove()
            $(this).html('')
        }
        $(this).parent().remove()
    });

    $(document).on('click', '.addPlaylistButton', function() {
        if ($('#linkInput').val()) {
            var i = $(this)
            $.getJSON('https://noembed.com/embed?url=', {format: 'json', url: $('#linkInput').val()}, function (data) {
                if (data.title) {
                    console.log(i.data('id'))
                    $.post('http://myDj/addSongToPlaylist', JSON.stringify({
                        id: i.data('id'),
                        link: $('#linkInput').val()
                    }));

                    var addPlaylist = $('#addPlaylist')
                    isDropDownOpen = false
                    addPlaylist.animate({height: '0', width: '0'});
                    setTimeout(function() {
                        addPlaylist.css('display', 'none');
                    }, 350);
                    $('#linkInput').val('')
                } else {
                    $.post('http://myDj/noSongtitle', JSON.stringify({}));
                }
            });
            
        }
    });

    $(document).on('click', '.song', function() {
        // console.log($(this).data('songid') + ' ' + $(this).data('link') + ' ' + $(this).parent().data('id'))
        $.post('http://myDj/playSongFromPlaylist', JSON.stringify({
            id: $(this).data('id'),
            link: $(this).data('link'),
            playlistId: $(this).parent().data('id')
        }));
    });

    window.addEventListener('message', (event) => {
        const e = event.data
        switch (e.type) {
            case "open":
                $('body').show();
                break;
            case "getPlaylists":
                e.songs.forEach((s, i) => {
                    $.getJSON('https://noembed.com/embed?url=', {format: 'json', url: s.link}, function (data) {
                        currentSongLabel = data.title;
                        s.label = currentSongLabel;
                        // console.log(s.label)
                    });
                })
                setTimeout(function() {
                    $('#playlists').html('')
                    var newHtml = $('#playlists').html()
                    e.playlists.forEach((v) => {
                        var songsHtml = ''
                        e.songs.forEach((s, i) => {
                            // console.log(s.playlist + ' == ' + v.id)
                            if (s.playlist == v.id) {
                                songsHtml = songsHtml + `<p class="song" id="song${s.id}" data-songid="${s.id}" data-link="${s.link}">${s.label}<i class="fas fa-trash-alt deleteSongs"></i></p>
                                `
                                // // console.log(songsHtml)
                            }
                            if (i == (Object.keys(e.songs).length-1)) {
                                // // console.log(123)
                                HighestPlayListId = v.id
                                newHtml += `
                                <div class="playlist" data-id="${v.id}">
                                    <button id="playlist${v.id}" class="playlistButton">${v.label}<i class="fas fa-trash-alt deletePlaylist"></i></button>
                                    <div id="songSpace${v.id}" class="songs" data-id="${v.id}" data-displayed="0">
                                    ${songsHtml}
                                    </div>
                                </div>`
                            }
                        })


                        
                    })
                    $('#playlists').html(newHtml)
                }, 500);
                $('#addPlaylist').html('')
                var newHtml = $('#addPlaylist').html()
                e.playlists.forEach((v) => {
                    newHtml += `<p class="addPlaylistButton" data-id="${v.id}">${v.label}</p>`
                })
                $('#addPlaylist').html(newHtml)
                
            
                break;
            case "updateSeconds":
                perc = parseInt($('#timeLineInside').css('max-width'))/e.maxDuration
                // console.log($('#timeLineInside').width()+perc)
                $('#timeLineInside').width($('#timeLineInside').width()+perc)
                if (e.secs > 59) {
                    var secs = Math.round((e.secs/60-Math.floor(e.secs/60))*60)
                    var min = Math.floor(e.secs/60)
                    if (secs < 10 && min < 10) $('#currentTime').text('0' + min + ':0' + secs)
                    else if (secs > 10 && min < 10) $('#currentTime').text('0' + min + ':' + secs)
                    else if (secs < 10 && min > 10) $('#currentTime').text(min + ':0' + secs)
                    else $('#currentTime').text(min + ':' + secs)
                } else {
                    if (e.secs < 10) {
                        $('#currentTime').text( '00:0' + e.secs)
                    } else {
                        $('#currentTime').text( '00:' + e.secs)
                    }
                }
                
                $('#maxTime').text(Math.floor(e.maxDuration/60) + ':' + Math.round((e.maxDuration/60-Math.floor(e.maxDuration/60))*60))
                if (e.maxDuration > 59) {
                    var secs = Math.round((e.maxDuration/60-Math.floor(e.maxDuration/60))*60)
                    var min = Math.floor(e.maxDuration/60)
                    if (secs < 10 && min < 10) $('#maxTime').text('0' + min + ':0' + secs)
                    else if (secs > 10 && min < 10) $('#maxTime').text('0' + min + ':' + secs)
                    else if (secs < 10 && min > 10) $('#maxTime').text(min + ':0' + secs)
                    else $('#maxTime').text(min + ':' + secs)
                } else {
                    if (e.maxDuration < 10) {
                        $('#maxTime').text('00:0' + e.maxDuration)
                    } else {
                        $('#maxTime').text('00:' + e.maxDuration)
                    }
                }
                break;
            case "updateSonginfos":
                $.getJSON('https://noembed.com/embed?url=', {format: 'json', url: e.link}, function (data) {
                    currentSongLabel = data.title;
                    // whenDone(e.link);
                    insertSonghistory(e.link, currentSongLabel);
                    $('#maxTime').text(e.maxDuration)
                    $('#currentSong').text(currentSongLabel);
                });
                $('#timeLineInside').width("3%")
                break;
            default:
                // console.log("this event doesn't exist");
                break;
        }
    });

    document.addEventListener("keydown", Close);

    function Close(event) {
        if (event.keyCode === 27) {
            $('body').hide()
            $.post('http://myDj/close', JSON.stringify({}));
        }
    }

    var songs
    var PlaylistIsVisible = false
    var currentPlaylistId = 0
   

    $(document).on('click', '.playlist', function() {
        songs = $(this).find('.songs')
        var bla = songs.find('p')
        // console.log(songs.data('id') + ' ' + $(this, '.songs').data('id') + ' | ' + bla.html())
        if (songs.data('id') == 'songhistory' && PlaylistIsVisible == false) {
            if (songs.data("displayed") == 0) {
                songs.css('display', 'block');
                songs.css('margin-bottom', '1vh');
                currentPlaylistId = songs.data('id')
                songs.animate({height: '100%'});
                setTimeout(function() {
                    // console.log('playlistsonghistory is visible')
                    songs.data("displayed", "1");
                    PlaylistIsVisible = true
                }, 500);
            }
        } else if ($(this, '.songs').data('id') == songs.data('id') && PlaylistIsVisible == false && bla.html()) {
            if (songs.data("displayed") == 0) {
                songs.css('display', 'block');
                songs.css('margin-bottom', '1vh');
                currentPlaylistId = songs.data('id')
                songs.animate({height: '100%'});
                setTimeout(function() {
                    // console.log('songs are visible')
                    songs.data("displayed", "1");
                    PlaylistIsVisible = true
                }, 500);
                
            }
        }
    });

    $(window).click(function(e) {
        target = document.getElementById(e.target.id) 
        // console.log('click1 playlist' + currentPlaylistId + ' ' + target + ' ' + songs + ' ' + PlaylistIsVisible)
        if (document.getElementById('playlist' + currentPlaylistId) == target && songs && PlaylistIsVisible) {
            songs.animate({height: '0'});
            songs.data("displayed", "0");
            songs.css('margin-bottom', '0');
            PlaylistIsVisible = false
        }
    });

    

    var outside = document.getElementById('timeLineOutside');
    var inside = document.getElementById('timeLineInside');

    outside.addEventListener('click', function(e) {
        inside.style.width = e.offsetX + "px";
        var pct = Math.floor((e.offsetX / outside.offsetWidth) * 100);
        // $.post('http://myDj/close', JSON.stringify({
            // pct: pct
        // }));
    }, false);

    function insertSonghistory(link, label) {
        var elem = $('#songSpacesonghistory');
        var html = elem.html()
        // console.log('!!!!HIER!!! ' + elem.html())
        if (html) {
            elem.html(html + '<p id="songsonghistory" data-link="' + link + '">' + label + '<i class="fas fa-trash-alt"></i></p>')
            // console.log('song added | 1 | ' + html + '<p id="songsonghistory" data-link="' + link + '">' + label + '<i class="fas fa-trash-alt"></i></p>')
        } else {
            elem.html('<p id="songsonghistory" data-link="' + link + '">' + label + '<i class="fas fa-trash-alt"></i></p>')
            // console.log('song added | 2 | ' + '<p id="songsonghistory" data-link="' + link + '">' + label + '<i class="fas fa-trash-alt"></i></p>')
        }
        
    }
});