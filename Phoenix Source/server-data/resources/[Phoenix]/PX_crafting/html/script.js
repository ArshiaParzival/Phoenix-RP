var timeout;
var opened;
var recipes;
var names;
// var level;
var inventory = {};
// var rawlevel;
var job;
var hidecraft;
var grade;
var categories;

function closeMenu() {
  $.post('https://PX_crafting/close', JSON.stringify({}));


  $("#main_container").fadeOut(400);
  timeout = setTimeout(function () {
    $("#main_container").html("");
    $("#main_container").fadeIn();
  }, 400);


}

function openCategory() {

  var first = '';


  var base = '<div class="" id="page"><!-- group -->' +
    '   <div class="clearfix grpelem scale-up-center" id="pu104-4"><!-- column -->' +
    '    <div class="clearfix colelem" id="u104-4" data-sizePolicy="fixed" data-pintopage="page_fixedCenter" data-leftAdjustmentDoneBy="pu104-4"><!-- content -->' +
    '     <p>Crafting Menu</p>' +
    '    </div>' +
    '    <div class="clearfix colelem" id="u139-4" data-sizePolicy="fixed" data-pintopage="page_fixedCenter" data-leftAdjustmentDoneBy="pu104-4"><!-- content -->' +

    '    </div>' +
    '    <div class="colelem" id="u136" data-sizePolicy="fixed" data-pintopage="page_fixedCenter" data-leftAdjustmentDoneBy="pu104-4"><!-- simple frame --></div>' +
    '    <div class="colelem" id="u107" data-sizePolicy="fixed" data-pintopage="page_fixedCenter" data-leftAdjustmentDoneBy="pu104-4"><!-- simple frame --></div>' +

    '<div id="recepies">';

  for (const [key1, value1] of Object.entries(categories)) {


    var add = false;


    for (const [key, value] of Object.entries(recipes)) {


      if (value.Category == key1) {

        // if (value.Level > level) {

        //   if (!hidecraft) {

        //     add = true;
        //   }


        // } else {

          if (value.requireBlueprint && (inventory[key + '_blueprint'] == 0 || inventory[key + '_blueprint'] == null)) {
            if (!hidecraft) {

              add = true;
            }
          } else {

            if (value.Jobs.includes(job) || Object.keys(value.Jobs).length == 0) {

              if (value.JobGrades.includes(grade) || Object.keys(value.JobGrades).length == 0) {
                add = true;
              } else {
                if (!hidecraft) {

                  add = true;
                }
              }
            } else {
              if (!hidecraft) {

                add = true;
              }
            }

          }

        // }


      }
    }


    if (add) {
      first = first + '    <div class="clearfix colelem recipe" data-category="' + key1 + '" onclick="openCrafting(this)" id="pu212"><!-- group -->' +
        '     <div class="gradient grpelem" id="u212" data-sizePolicy="fixed" data-pintopage="page_fixedCenter" data-leftAdjustmentDoneBy="pu212"><!-- simple frame --></div>' +
        '     <div class="clearfix grpelem" id="u225-4" data-sizePolicy="fixed" data-pintopage="page_fixedCenter" data-leftAdjustmentDoneBy="pu212"><!-- content -->' +
        '      <p>' + value1.Label + '</p>' +
        '     </div>' +
        '     <div class="museBGSize grpelem" id="u264" style="background: url(img/' + value1.Image + '.png) no-repeat center; background-size: 120%; " data-sizePolicy="fixed" data-pintopage="page_fixedCenter" data-leftAdjustmentDoneBy="pu212"><!-- simple frame --></div>' +
        '    </div>';
    }


  }

  base = base + first + '</div>' +


    '   </div>' +

    '   <div class="verticalspacer" data-offset-top="0" data-content-above-spacer="1060" data-content-below-spacer="0" data-sizePolicy="fixed" data-pintopage="page_fixedLeft"></div>' +
    '   <div class="grpelem" id="u559"><!-- simple frame --></div>' +
    '  </div>';


  $("#main_container").append(base);

  $(".recipe").hover(function () {
    playClickSound();
  });


  // $("#u139-4").text(level + ' LEVEL');
  // setProgress((rawlevel % 100));


}

function openCrafting(t) {

  $("#main_container").html('');

  var first = '';
  var second = '';
  var category = t.dataset.category;

  var base = '<div class="" id="page"><!-- group -->' +
    '   <div class="clearfix grpelem scale-up-center" id="pu104-4"><!-- column -->' +
    '    <div class="clearfix colelem" id="u104-4" data-sizePolicy="fixed" data-pintopage="page_fixedCenter" data-leftAdjustmentDoneBy="pu104-4"><!-- content -->' +
    '     <p>Crafting Menu</p>' +
    '    </div>' +
    '    <div class="clearfix colelem" id="u139-4" data-sizePolicy="fixed" data-pintopage="page_fixedCenter" data-leftAdjustmentDoneBy="pu104-4"><!-- content -->' +

    '    </div>' +
    '    <div class="colelem" id="u136" data-sizePolicy="fixed" data-pintopage="page_fixedCenter" data-leftAdjustmentDoneBy="pu104-4"><!-- simple frame --></div>' +
    '    <div class="colelem" id="u107" data-sizePolicy="fixed" data-pintopage="page_fixedCenter" data-leftAdjustmentDoneBy="pu104-4"><!-- simple frame --></div>' +

    '<div id="recepies">';

  for (const [key, value] of Object.entries(recipes)) {

    var date = new Date(0);
    date.setSeconds(value.Time);
    var timeString = date.toISOString().substr(14, 5);

    if (value.Category == category) {


      // if (value.Level > level) {

      //   if (!hidecraft) {

      //     second = second + '    <div class="clearfix colelem recipe" onclick="inspect(this)" data-item="' + key + '" style="opacity: 0.5;" id="pu212"><!-- group -->' +
      //       '     <div class="gradient grpelem" id="u212" data-sizePolicy="fixed" data-pintopage="page_fixedCenter" data-leftAdjustmentDoneBy="pu212"><!-- simple frame --></div>' +
      //       '     <div class="clearfix grpelem" id="u225-4" data-sizePolicy="fixed" data-pintopage="page_fixedCenter" data-leftAdjustmentDoneBy="pu212"><!-- content -->' +
      //       '      <p>' + String(names[key]).toUpperCase() + '</p>' +
      //       '     </div>' +
      //       '     <div class="museBGSize grpelem" id="u264" style="background: url(img/' + key + '.png) no-repeat center; background-size: 120%; " data-sizePolicy="fixed" data-pintopage="page_fixedCenter" data-leftAdjustmentDoneBy="pu212"><!-- simple frame --></div>' +
      //       '     <div class="rounded-corners clearfix grpelem" id="u270-4" data-sizePolicy="fixed" data-pintopage="page_fixedCenter" data-leftAdjustmentDoneBy="pu212"><!-- content -->' +
      //       '      <p>' + timeString + '</p>' +
      //       '     </div>' +
      //       '     <div class="rounded-corners clearfix grpelem" id="u417-4" data-sizePolicy="fixed" data-pintopage="page_fixedCenter" data-leftAdjustmentDoneBy="pu212"><!-- content -->' +
      //       '      <p> X' + value.Amount + '</p>' +
      //       '     </div>' +
      //       '    </div>';
      //       // '     <div class="rounded-corners clearfix grpelem" id="u413-4" data-sizePolicy="fixed" data-pintopage="page_fixedCenter" data-leftAdjustmentDoneBy="pu212"><!-- content -->' +
      //       // '      <p>' + value.Level + ' LVL</p>' +
      //       // '     </div>' +
      //   }


      // } else {

        if (value.requireBlueprint && (inventory[key + '_blueprint'] == 0 || inventory[key + '_blueprint'] == null)) {
          if (!hidecraft) {

            second = second + '    <div class="clearfix colelem recipe" data-item="' + key + '" onclick="inspect(this)" style="opacity: 0.5;" id="pu212"><!-- group -->' +
              '     <div class="gradient grpelem" id="u212" data-sizePolicy="fixed" data-pintopage="page_fixedCenter" data-leftAdjustmentDoneBy="pu212"><!-- simple frame --></div>' +
              '     <div class="clearfix grpelem" id="u225-4" data-sizePolicy="fixed" data-pintopage="page_fixedCenter" data-leftAdjustmentDoneBy="pu212"><!-- content -->' +
              '      <p>' + String(names[key]).toUpperCase() + '</p>' +
              '     </div>' +
              '     <div class="museBGSize grpelem" id="u264" style="background: url(img/' + key + '.png) no-repeat center; background-size: 120%; " data-sizePolicy="fixed" data-pintopage="page_fixedCenter" data-leftAdjustmentDoneBy="pu212"><!-- simple frame --></div>' +
              '     <div class="rounded-corners clearfix grpelem" id="u270-4" data-sizePolicy="fixed" data-pintopage="page_fixedCenter" data-leftAdjustmentDoneBy="pu212"><!-- content -->' +
              '      <p>' + timeString + '</p>' +
              '     </div>' +
              '     <div class="rounded-corners clearfix grpelem" id="u417-4" data-sizePolicy="fixed" data-pintopage="page_fixedCenter" data-leftAdjustmentDoneBy="pu212"><!-- content -->' +
              '      <p> X' + value.Amount + '</p>' +
              '     </div>' +
              '    </div>';
              // '     <div class="rounded-corners clearfix grpelem" id="u413-4" data-sizePolicy="fixed" data-pintopage="page_fixedCenter" data-leftAdjustmentDoneBy="pu212"><!-- content -->' +
              // '      <p>' + value.Level + ' LVL</p>' +
              // '     </div>' +
          }
        } else {

          if (value.Jobs.includes(job) || Object.keys(value.Jobs).length == 0) {

            if (value.JobGrades.includes(grade) || Object.keys(value.JobGrades).length == 0) {
              first = first + '    <div class="clearfix colelem recipe" data-item="' + key + '" onclick="inspect(this)" id="pu212"><!-- group -->' +
                '     <div class="gradient grpelem" id="u212" data-sizePolicy="fixed" data-pintopage="page_fixedCenter" data-leftAdjustmentDoneBy="pu212"><!-- simple frame --></div>' +
                '     <div class="clearfix grpelem" id="u225-4" data-sizePolicy="fixed" data-pintopage="page_fixedCenter" data-leftAdjustmentDoneBy="pu212"><!-- content -->' +
                '      <p>' + String(names[key]).toUpperCase() + '</p>' +
                '     </div>' +
                '     <div class="museBGSize grpelem" id="u264" style="background: url(img/' + key + '.png) no-repeat center; background-size: 120%; " data-sizePolicy="fixed" data-pintopage="page_fixedCenter" data-leftAdjustmentDoneBy="pu212"><!-- simple frame --></div>' +
                '     <div class="rounded-corners clearfix grpelem" id="u270-4" data-sizePolicy="fixed" data-pintopage="page_fixedCenter" data-leftAdjustmentDoneBy="pu212"><!-- content -->' +
                '      <p>' + timeString + '</p>' +
                '     </div>' +
                '     <div class="rounded-corners clearfix grpelem" id="u417-4" data-sizePolicy="fixed" data-pintopage="page_fixedCenter" data-leftAdjustmentDoneBy="pu212"><!-- content -->' +
                '      <p> X' + value.Amount + '</p>' +
                '     </div>' +
                '    </div>';
                // '     <div class="rounded-corners clearfix grpelem" id="u413-4" data-sizePolicy="fixed" data-pintopage="page_fixedCenter" data-leftAdjustmentDoneBy="pu212"><!-- content -->' +
                // '      <p>' + value.Level + ' LVL</p>' +
                // '     </div>' +
            } else {
              if (!hidecraft) {

                second = second + '    <div class="clearfix colelem recipe" data-item="' + key + '" onclick="inspect(this)" style="opacity: 0.5;" id="pu212"><!-- group -->' +
                  '     <div class="gradient grpelem" id="u212" data-sizePolicy="fixed" data-pintopage="page_fixedCenter" data-leftAdjustmentDoneBy="pu212"><!-- simple frame --></div>' +
                  '     <div class="clearfix grpelem" id="u225-4" data-sizePolicy="fixed" data-pintopage="page_fixedCenter" data-leftAdjustmentDoneBy="pu212"><!-- content -->' +
                  '      <p>' + String(names[key]).toUpperCase() + '</p>' +
                  '     </div>' +
                  '     <div class="museBGSize grpelem" id="u264" style="background: url(img/' + key + '.png) no-repeat center; background-size: 120%; " data-sizePolicy="fixed" data-pintopage="page_fixedCenter" data-leftAdjustmentDoneBy="pu212"><!-- simple frame --></div>' +
                  '     <div class="rounded-corners clearfix grpelem" id="u270-4" data-sizePolicy="fixed" data-pintopage="page_fixedCenter" data-leftAdjustmentDoneBy="pu212"><!-- content -->' +
                  '      <p>' + timeString + '</p>' +
                  '     </div>' +
                  '     <div class="rounded-corners clearfix grpelem" id="u417-4" data-sizePolicy="fixed" data-pintopage="page_fixedCenter" data-leftAdjustmentDoneBy="pu212"><!-- content -->' +
                  '      <p> X' + value.Amount + '</p>' +
                  '     </div>' +
                  '    </div>';
                  // '     <div class="rounded-corners clearfix grpelem" id="u413-4" data-sizePolicy="fixed" data-pintopage="page_fixedCenter" data-leftAdjustmentDoneBy="pu212"><!-- content -->' +
                  // '      <p>' + value.Level + ' LVL</p>' +
                  // '     </div>' +
              }
            }
          } else {
            if (!hidecraft) {

              second = second + '    <div class="clearfix colelem recipe" data-item="' + key + '" onclick="inspect(this)" style="opacity: 0.5;" id="pu212"><!-- group -->' +
                '     <div class="gradient grpelem" id="u212" data-sizePolicy="fixed" data-pintopage="page_fixedCenter" data-leftAdjustmentDoneBy="pu212"><!-- simple frame --></div>' +
                '     <div class="clearfix grpelem" id="u225-4" data-sizePolicy="fixed" data-pintopage="page_fixedCenter" data-leftAdjustmentDoneBy="pu212"><!-- content -->' +
                '      <p>' + String(names[key]).toUpperCase() + '</p>' +
                '     </div>' +
                '     <div class="museBGSize grpelem" id="u264" style="background: url(img/' + key + '.png) no-repeat center; background-size: 120%; " data-sizePolicy="fixed" data-pintopage="page_fixedCenter" data-leftAdjustmentDoneBy="pu212"><!-- simple frame --></div>' +
                '     <div class="rounded-corners clearfix grpelem" id="u270-4" data-sizePolicy="fixed" data-pintopage="page_fixedCenter" data-leftAdjustmentDoneBy="pu212"><!-- content -->' +
                '      <p>' + timeString + '</p>' +
                '     </div>' +
                '     <div class="rounded-corners clearfix grpelem" id="u417-4" data-sizePolicy="fixed" data-pintopage="page_fixedCenter" data-leftAdjustmentDoneBy="pu212"><!-- content -->' +
                '      <p> X' + value.Amount + '</p>' +
                '     </div>' +
                '    </div>';
                // '     <div class="rounded-corners clearfix grpelem" id="u413-4" data-sizePolicy="fixed" data-pintopage="page_fixedCenter" data-leftAdjustmentDoneBy="pu212"><!-- content -->' +
                // '      <p>' + value.Level + ' LVL</p>' +
                // '     </div>' +
            }
          }

        }

      // }

    }
  }

  base = base + first + second + '</div>' +


    '   </div>' +

    '   <div class="verticalspacer" data-offset-top="0" data-content-above-spacer="1060" data-content-below-spacer="0" data-sizePolicy="fixed" data-pintopage="page_fixedLeft"></div>' +
    '   <div class="grpelem" id="u559"><!-- simple frame --></div>' +
    '  </div>';


  $("#main_container").append(base);

  $(".recipe").hover(function () {
    playClickSound();
  });

  // $("#u139-4").text(level + ' LEVEL');
  // setProgress((rawlevel % 100));


}

$(document).keyup(function (e) {
  if (e.keyCode === 27) {

    closeMenu();

  }

});

function addToQueue(item, time, id) {

  var date = new Date(0);
  date.setSeconds(time);
  var timeString = date.toISOString().substr(14, 5);

  if ($("#" + id).length) {


    $("#" + id).find("#u547-2").text(timeString);

    if (time == 0) {
      $("#" + id).fadeOut();
      setTimeout(function () {
        $("#" + id).remove();
      }, 3000);
    }

  } else {
    var base = '    <div class="slide-left queue" id="' + id + '"><!-- group -->' +
      '     <div class="gradient grpelem" id="u544" data-sizePolicy="fixed" data-pintopage="page_fixedCenter" data-leftAdjustmentDoneBy="pu544"><!-- simple frame --></div>' +
      '     <div class="clearfix grpelem" id="u545-4" data-sizePolicy="fixed" data-pintopage="page_fixedCenter" data-leftAdjustmentDoneBy="pu544"><!-- content -->' +
      '      <p>' + String(names[item]).toUpperCase() + '</p>' +
      '     </div>' +
      '     <div class="museBGSize grpelem" style="background: url(img/' + item + '.png) no-repeat center; background-size: 120%; " id="u546" data-sizePolicy="fixed" data-pintopage="page_fixedCenter" data-leftAdjustmentDoneBy="pu544"><!-- simple frame --></div>' +
      '     <div class="rounded-corners clearfix grpelem" id="u547-4" data-sizePolicy="fixed" data-pintopage="page_fixedCenter" data-leftAdjustmentDoneBy="pu544"><!-- content -->' +
      '      <p id="u547-2">' + timeString + '</p>' +
      '     </div>' +
      '    </div>';

    $("#ppu586").append(base);
  }

}

function craft(t) {
  var item = t.dataset.item;
  $.post('https://PX_crafting/craft', JSON.stringify({
    item: item
  }));


}

function setProgress(p) {

  var prog = (398 / 100) * p;


  $("#u136").animate({
    width: prog
  }, 500, function () {

  });

}

function inspect(t) {

  if (opened != t) {
    opened = t

    $("#pu386").remove();


    var item = recipes[t.dataset.item]
    var ingredients = item.Ingredients

    var date = new Date(0);
    date.setSeconds(item.Time);
    var timeString = date.toISOString().substr(14, 5);

    var base = '   <div class="slide-bottom " id="pu386"><!-- group -->' +
      '    <div class="gradient grpelem" id="u386" data-sizePolicy="fixed" data-pintopage="page_fixedCenter" data-leftAdjustmentDoneBy="pu386"><!-- simple frame --></div>' +
      '    <div class="museBGSize grpelem" id="u389" style="background: url(img/' + t.dataset.item + '.png) no-repeat center; background-size: 120%; " data-sizePolicy="fixed" data-pintopage="page_fixedCenter" data-leftAdjustmentDoneBy="pu386"><!-- simple frame --></div>' +

      '     <button class="ripple" id="u407-4" data-item="' + t.dataset.item + '" onclick="craft(this)" data-sizePolicy="fixed" data-pintopage="page_fixedCenter"><!-- content -->' +
      '      <p>CRAFT</p>' +
      '     </button>' +

      '    <div class="clearfix grpelem" id="u457-4" data-sizePolicy="fixed" data-pintopage="page_fixedCenter" data-leftAdjustmentDoneBy="pu386"><!-- content -->' +
      '     <p>' + String(names[t.dataset.item]).toUpperCase() + '</p>' +
      '    </div>' +
      '    <div class="rounded-corners clearfix grpelem" id="u535-4" data-sizePolicy="fixed" data-pintopage="page_fixedCenter" data-leftAdjustmentDoneBy="pu386"><!-- content -->' +
      '     <p>' + timeString + '</p>' +
      '    </div>' +
      '    <div class="rounded-corners clearfix grpelem" id="u523-4" data-sizePolicy="fixed" data-pintopage="page_fixedCenter" data-leftAdjustmentDoneBy="pu386"><!-- content -->' +
      '     <p>X' + item.Amount + '</p>' +
      '    </div>' +
      '    <div class="clearfix grpelem" id="u541-4" data-sizePolicy="fixed" data-pintopage="page_fixedCenter" data-leftAdjustmentDoneBy="pu386"><!-- content -->' +
      '     <p>Vasayel Mored Niaz</p>' +
      '    </div>' +

      '<div id="ingredients">';

      // '    <div class="rounded-corners clearfix grpelem" id="u538-4" data-sizePolicy="fixed" data-pintopage="page_fixedCenter" data-leftAdjustmentDoneBy="pu386"><!-- content -->' +
      // '     <p>' + item.Level + ' LVL</p>' +
      // '    </div>' +
    var first = '';
    var second = '';


    for (const [key, value] of Object.entries(ingredients)) {

      if (inventory[key] >= value) {
        first = first + '<div class="ingredient" id="' + key + '">' +
          '<div id="ingredient-text">' + names[key] + '</div>' +
          '<div id="ingredient-x">' + value + 'X</div>' +
          '<div id="ingredient-logo" style="background: url(img/' + key + '.png) no-repeat center; background-size: 120%; "></div>' +
          '</div>';
      } else {
        second = second + '<div class="ingredient" id="' + key + '" style="opacity:0.5;">' +
          '<div id="ingredient-text">' + names[key] + '</div>' +
          '<div id="ingredient-x">' + value + 'X</div>' +
          '<div id="ingredient-logo" style="background: url(img/' + key + '.png) no-repeat center; background-size: 120%; "></div>' +
          '</div>';
      }


    }


    base = base + first + second + '</div>' +

      '   </div>';

    $("#page").append(base);
  }


}


function playClickSound() {
  var audio = document.getElementById("clickaudio");
  audio.volume = 0.05;
  audio.play();
}


window.addEventListener('message', function (event) {


  var edata = event.data;

  if (edata.type == "addqueue") {
    addToQueue(edata.item, edata.time, edata.id);
  }
  if (edata.type == "crafting") {
    for (const [key, value] of Object.entries(recipes[edata.item].Ingredients)) {
      if (inventory[key] >= value) {
        inventory[key] = inventory[key] - value;
      }


      if (inventory[key] < value) {
        $(document).find("#" + key).css("opacity", "0.5");
      }
    }
  }

  if (edata.type == "open") {

    // level = (edata.level - (edata.level % 100)) / 100;
    // rawlevel = edata.level;
    recipes = edata.recipes;
    inventory = edata.inventory;
    names = edata.names;
    job = edata.job;
    hidecraft = edata.hidecraft;
    grade = edata.grade;
    categories = edata.categories
    openCategory();


  }


});