function openLeftNav() {
    document.getElementById("navPanel").style.width = "250px";
}

function closeLeftNav() {
    closeLeftNav2();
    document.getElementById("navPanel").style.width = "0px";
}

var leftNav2StateOpen = false;
function openLeftNav2() {
    document.getElementById("navCategory").style.background = "#E01A22";
    document.getElementById("navCategory").style.color = "#FFFFFF";
    document.getElementById("navCategory").children[0].style.color = "#FFFFFF";

    document.getElementById("navPanel2").style.borderLeft = "2px solid #D7D7D7";
    document.getElementById("navPanel2").style.width = "250px";
    leftNav2StateOpen = true;
}

function closeLeftNav2() {

    document.getElementById("navPanel2").style.width = "0px";
    document.getElementById("navPanel2").style.border = "none";

    // http://stackoverflow.com/questions/18796509/clear-all-javascript-applied-styles
    $("#navCategory").removeAttr("style");
    $("#navCategory > i").removeAttr("style");

    leftNav2StateOpen = false;
}

function toggleLeftNav2() {
    if (leftNav2StateOpen) closeLeftNav2();
    else openLeftNav2();
}

// http://stackoverflow.com/questions/152975/how-do-i-detect-a-click-outside-an-element
$('html').click(function(event) { 
    //alert(leftNavStateOpen + " : " + $(event.target).is('#navPanel') + " : " + (leftNavStateOpen && !$(event.target).is('#navPanel')));
    if(!($(event.target).is('#navButton') || 
         $(event.target).is('#navPanel')||
         $(event.target).parents("#navPanel").is("#navPanel") ||
         $(event.target).is('#navPanel2') ||
         $(event.target).parents("#navPanel2").is("#navPanel2"))) closeLeftNav();
});