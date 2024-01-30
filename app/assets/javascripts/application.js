//= require jquery
//= require jquery_ujs
//= require_tree .

// If I had some more time, I'd ensure this is *only* loaded after the user logs in.
$(document).ready(function() {
  timer = new timer();

  // refresh the page every 30 seconds if the user is on the votes screen
  if(onVotesScreen()) {
    window.setTimeout(function() {
      window.location.reload();
    }, 10000);
  }
});

function timer() {
    var timerId;

    // this is partly a "found on StackOverflow" function
    // I've been doing entirely backend for about the past 2.5 years,
    // so my JS is a little rusty.
    // This function sets an interval of a second, and recursively calls itself
    // until time is up. At that point, it redirects to the login page.
    startTimer = function()
    {
            setTimeout(function()
                       {
                           if(time > 0)
                           {
                               time--;
                               generateTime(time);
                               startTimer();
                           } else {
                               location.replace("/sessions/new")
                           }
                       }, 1000);

    }

    // setting the start time by getting the cookie and adding 5 minutes
    var rubyDate = getStringTime(document.cookie);
    if(rubyDate == "") {
        if (!onLoginScreen() && !onVotesScreen()) {
            location.replace("/sessions/new")
        }
    } else {
        time = getTimeRemaining(rubyDate);
        if(time > 1) {
            startTimer();
        } else {
            if (!onLoginScreen()) {
                location.replace("/sessions/new")
            }
        }
    }
}

// parses time from cookie
function getStringTime(cookie) {
    return cookie.split(";")[0].split("=")[1].replaceAll("%3A", ":").replaceAll("+", " ");
}

// checks if user is on login screen
function onLoginScreen() {
    return window.location.pathname == "/sessions/new";
}

// checks if user is on votes screen
function onVotesScreen() {
    return window.location.pathname == "/votes";
}

// gets time remaining in seconds
// takes sign in time, adds 5 minutes, and subtracts current time
function getTimeRemaining(rubyDate) {
    var dateTime = Date.parse(rubyDate);
    dateTime = dateTime + (5 * 60000);
    return (dateTime - Date.now()) / 1000;
}

// sets the display timer
function generateTime(time)
{
    var second = Math.floor(time % 60);
    var minute = Math.floor(time / 60) % 60;

    second = (second < 10) ? '0'+second : second;
    minute = (minute < 10) ? '0'+minute : minute;
    if (second < 1 && minute == 0) {
        $('div.timer span.second').html("");
        $('div.timer span.minute').html("");
    } else {
        $('div.timer span.second').html(second + " time remaining");
        $('div.timer span.minute').html(minute + ":");
    }
}
