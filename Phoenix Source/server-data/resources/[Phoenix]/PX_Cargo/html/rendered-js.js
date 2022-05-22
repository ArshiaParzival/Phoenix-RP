window.addEventListener("message", function(event){
  if(event.data.show == true){
    $('body').show();
  } else if(event.data.show == false){
    $('body').hide();
  } else if(event.data.refresh == true) {
    $('.command-input').show();
    con.find(".command-line").remove();
    cli.consolize();
  }
});

// jQuery Cache objects
var doc = $(document);
var con = $("#console");
var com = $(".command");
// Console History
var hist = [];
var histUp = [];
var histDo = [];

// Focus on Input :)
doc.on('mouseup', function () {
  com.focus();
});

// Helper for print in `console` xD
function Output() {
  this.puts = function (message) {
    // Maybe i should escape string ?)
    $("<div class=line><span class=white>" + message + "</span></div>").
    appendTo("div.command-line");
  };
}

// Command Line Object
function CommandLine(console) {

  // jQuery object
  this.console = console;
  // Commands register in class
  this.commands = [];

  // Register some command..
  this.on = function (regexp, callback) {
    this.commands.push({
      "regexp": regexp,
      "callback": callback });

  };

  // Get commands :v
  this.get = function () {
    return this.commands;
  };

  // Just prepare the stage
  this.consolize = function () {
    $("<div class='command-line'></div>").prependTo(this.console);
  };

  // Set the attributes
  this.set = function (config) {
    if (config.auth != null) this.console.find(".command-input *[data-auth]").
    text(config.auth);
    if (config.route != null) this.console.find(".command-input *[data-route]").
    text(config.route);
    // What the hell it's doing this here?
    if (config.input != null) this.console.find(".command-input *[data-input]").
    text(config.input);
  };
}

// Command Line
var cli = new CommandLine(con);

// Prepare the command-history
cli.consolize();

cli.on("^(.+)$", function (output, matches) {
  hist.push(matches[1]);
  return true;
});

cli.on("^echo\\s[\"\']?\\b(.+)\\b\\1?", function (output, matches) {
  output.puts(matches[1]);
});

cli.on("^ls\\s[\"\']?\\b(.+)\\b\\1?", function (output, matches) {
  output.puts("Mani.txt  sendposition.sh  Phoenix");
});

cli.on("^ls\s?$", function (output, matches) {
  output.puts("Mani.txt  sendposition.sh  Phoenix");
});

cli.on("^bash\s?$", function (output, matches) {
  output.puts("[help] Dastore Bash Baraye Ejraye file haye .sh hastesh");
});

cli.on("^bash\\s[\"\']?\\b(.+)\\b\\1?", function (output, matches) {
  if(matches[1] == 'sendposition.sh') {
    $('.command-input').hide();
    output.puts('Mohasebe Mokhtasate Drop Cargo');
    setTimeout(() => {
      output.puts('Tabdil Mokhtasat be code binary');
      setTimeout(() => {
        output.puts('Ersale Etela`at be nazdik tarin borje mokhaberati');
        setTimeout(() => {
          output.puts('Entezar baraye Daryafte Natije . . .');
          setTimeout(() => {
            output.puts('Havapeyma ta 15 daqiqe dige be mokhtasate morede nazar mirese');
            $.post('http://PX_Cargo/endhackprocess');
          }, 10000);
        }, 5000);
      }, 5000);
    }, 5000);
  } else {
    output.puts('File morede nazar peyda nashod va ya qabeliate Ejra nadarad');
  }
});

cli.on("^clear\s?$", function (output) {
  con.find(".command-line").remove();
  cli.consolize();
});

cli.on("^help\s?$", function (output) {
  // On command
  output.puts("[ls] - Nemayeshe file haye dakhele poshe");
  output.puts("[bash] - Run kardan file .sh");
});

cli.on("^cd ([a-z0-9\/\-\_]+)", function (output, matches) {
  cli.set({
    "route": matches[1] });
});

// Default output || User catcher
cli.on("([a-z0-9\-\_]+)", function (output, match) {
  output.puts(match[1] + ": Dastor Peyda nashod, Baraye Rahnamayi dastore \"help\" ro vared konid");
});

document.onkeyup = function(data){
  if(data.which == 27){
    $('body').hide();
    $.post('http://PX_Cargo/close');
  }
};

// When the key return is pressed
com.on('keydown', function (e) {
  var key = e.which;
  // Equal `Return`
  if (key == 13) {
    // Register the action
    var input = con.find(".command-input");
    var result = $(input.html()).appendTo(con.find(".command-line"));
    result.find(".command").
    val(com.val()).
    removeAttr("data-input").
    attr('disabled', 'disabled');

    // Get all register commands
    var commands = cli.get();
    // Process the next command
    var next = true;

    commands.forEach(function (command) {
      // Regular Expresion
      var regexp = command.regexp;
      if (typeof command.regexp === 'string')
      regexp = new RegExp(command.regexp, "i");
      // Set output
      var output = new Output();
      var match = regexp.test(com.val()); // get if regexp match as bool
      var matches = regexp.exec(com.val()); // get group matches
      // Run Callback
      if (match && next)
        // if next == true keep processing commands :D
        next = command.callback(output, matches);
    });

    // Input is empty now :)
    com.val("");

    // Focus again & scroll to bottom
    com.focus();
    $("html, body").animate({
      scrollTop: $(document).height() },
    400);
    histUp = hist;
  } else if (key == 38) {
    var tmph = histUp.pop();
    if (tmph != undefined) {
      histDo.push(tmph);
      com.val(tmph);
    }
  } else if (key == 40) {
    var tmph = histDo.pop();
    if (tmph != undefined)
    histUp.push(tmph);
    com.val(tmph);
  }
});
//# sourceURL=pen.js