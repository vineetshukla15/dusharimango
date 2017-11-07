function isEmptyValue (strToCheck) {
    //alert(strToCheck + " : " + typeof strToCheck);
    if ( (typeof strToCheck === 'undefined') || 
         (typeof strToCheck === 'String' && (strToCheck.trim().length == 0 || strToCheck.trim().toLowerCase() == 'null')) ||
         (strToCheck === null) )
        return true;
    else
        return false;
}

function getPercentageString (strVal) {
    if (isEmptyValue (strVal)) return 'N.A.';
    else if (typeof Number(strVal) === NaN) return strVal;
    else return Number(strVal) + "%";
}

function getTextString (strVal) {
    if (isEmptyValue (strVal)) return 'N.A.';
    else return strVal;
}

function getNumberString (strVal) {
    if (isEmptyValue (strVal)) return 'N.A.';
    else return Number(strVal);
}

function getDollarConvertedShortValue (strNum) {
    if (isEmptyValue (strNum)) return 'N.A.';
    else if (typeof Number(strNum) === NaN) return strNum;
    else if (Number(strNum) < 100000) return '<$0.1M';
    else return "$" + convertNumberToMillionShortForm (strNum); 
}

function convertNumberToShortForm (strNum) {
    if (isEmptyValue (strNum)) return 'N.A.';
    else if (typeof Number(strNum) === NaN) return strNum;
    else {
        var num = Number(strNum);
        if (num < 10) return '<10';
        else if (num < 10000) return num;
        else if (num < 100000)
            return Math.round(num/1000) + "K";
        else return (num/1000000).toFixed(1) + "M"
    }
}

function convertNumberToMillionShortForm (strNum) {
    if (isEmptyValue (strNum)) return 'N.A.';
    else if (typeof Number(strNum) === NaN) return strNum;
    else {
        var num = Number(strNum);
        if (num < 100000) return '<0.1M';
        else return (num/1000000).toFixed(1) + "M"
    }
}

function formatNumberWithSeperator (strNum) {
    if (isEmptyValue (strNum)) return 'N.A.';
    else if (typeof Number(strNum) === NaN) return strNum;
    else {
        return strNum; // TODO: fix this
    }
}

function calculateFraction(nom, denom) {
    if (typeof Number(nom) === NaN ||
        isEmptyValue (nom) ||
        typeof Number(denom) === NaN ||
        isEmptyValue (denom) ||
        Number(denom) <= 0) return 'N.A.';
    else {
        return (nom/denom).toFixed(1);
    }
}

var reportColors = ["#FFFFFF", "#E01A22", "#4C424C", "#87A3B8", "#155277", "#68A280", "#066757", "#E7E7E7", "#F0F0F0"];

function populateFooterBrandLinks (divId, brandList){
    
    var container = $('#' + divId);
    for (var i = 0; i < brandList.length; i++) {
        
        var name = brandList[i].name;
        if (name.length > 20) //continue; // TODO: fix this
            name = name.substring(0,18) + '..';
        
        var colDiv = document.createElement('div');
        //colDiv.className = "col-xs-6 col-sm-3 col-md-2";
        colDiv.className = "col-xs-6 col-sm-4 col-md-3 col-lg-2";
        colDiv.style.padding = '0px';
        
        var pElem = document.createElement('p');
        
        var aElem = document.createElement('a');
        aElem.href = getSEOurl ('/brand/', brandList[i].brand_id, brandList[i].name);
        aElem.innerText = name;
        
        pElem.appendChild(aElem);
        colDiv.appendChild(pElem);
        
        container.append(colDiv);
    }
    
}

function getSEOurl (baseurl, id, name) {
    return baseurl + id + '-' + name.replace(/\s/g, '-').replace(/\//g, '').replace(/\%/g, 'percent');
}


    /* https://css-tricks.com/snippets/jquery/append-site-overlay-div/ */
    function renderOverlayForDetailsInput () {
        var docHeight = $(document).height();
        $("body > #overlay").css( "height", docHeight);
        $("body > #overlay").show();
    }
    
    function submitDetailsForFullAccess () {
        var params = {};
        params.name = $("#nameInput").val();
        params.email = $("#emailInput").val();
        params.company = $("#companyInput").val();
        params.desc = $("#descInput").val();
        

        $.get("/access_request", params, function(data, status){
                                        //alert("Data: " + JSON.stringify(data) + "\nStatus: " + status);
                                        handleAccessReqResponse(data);
                                    });
        
       
    }
    
    function handleAccessReqResponse(data) {
        $("#accessDetail").html("<p style='color:#FFFFFF;font:LatoWebThin;font-size:20px;'>" + data[0].status +"</p>");
        setTimeout(closeOverlay, 2000);
    }
    
    function closeOverlay(){
        $("body > #overlay").hide();
    }
    
    
    function renderReportVideoOverlay (reportLink) {
        $("#rv-Detail > p.videoTitle").text ('Report ' + reportLink.getAttribute("data-title"));
        $("#rv-contentId").val(reportLink.getAttribute("data-id"));
        var docHeight = $(document).height();
        $("#overlay-reportVideo").css( "height", docHeight);
        $("#overlay-reportVideo").show();
    }
    
    function reportVideo () {
        var name = $("#rv-nameInput").val();
        var email = $("#rv-emailInput").val();
        var emailValidator = new RegExp('^[a-zA-Z0-9.!#$%&’*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)*$');
        var companyName = $("#rv-companyNameInput").val();
        var phNum = $("#rv-PhNumInput").val();
        var desc = $("#rv-descInput").val();

        if (typeof name === 'undefined' || name.trim().length == 0) alert('Please enter your full name');
        else if (!emailValidator.test(email)) alert('Please enter a valid official email address');
        else if (typeof companyName === 'undefined' || companyName.trim().length == 0) alert('Please provide the name of the company that owns the rights to this video');
        else if (typeof phNum === 'undefined' || phNum.trim().length == 0) alert('Please provide the phone number that we can call to confirm the DMCA request');
        else if (typeof desc === 'undefined' || desc.trim().length < 100) alert('Please tell us more about your DMCA request. Which company owns the rights to this video. How are you affiliate and authorized to report DMCA.\nMin 100 chars, Max 1000 chars');
        else {
            var params = {};
            params.content = $("#rv-contentId").val();
            params.name = $("#rv-nameInput").val();
            params.email = $("#rv-emailInput").val();
            params.company = $("#rv-companyNameInput").val();
            params.phone = $("#rv-PhNumInput").val();
            params.desc = $("#rv-descInput").val();
            

            $.get("/report_video", params, function(data, status){
                                            //alert("Data: " + JSON.stringify(data) + "\nStatus: " + status);
                                            handleReportVideoResponse(data);
                                        });
        }
    }
    
    function handleReportVideoResponse(data) {
        alert(data[0].status);
        closeReportVideoOverlay();
    }
    
    function closeReportVideoOverlay(){
        $("#overlay-reportVideo").hide();
    }
    
    
    function renderFreeTrialOverlay (reportLink) {
        var docHeight = $(document).height();
        $("#overlay-freetrial").css( "height", docHeight);
        $("#overlay-freetrial").show();
    }
    
    function requestFreeTrial () {
        var email = $("#ft-emailInput").val();
        var emailValidator = new RegExp('^[a-zA-Z0-9.!#$%&’*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)*$');

        if (!emailValidator.test(email)) alert('Please enter a valid email address');
        else {
            var params = {};
            params.email = $("#ft-emailInput").val();
            params.brands = $("#ft-brandsInput").val();
            
            $.get("/requestFT", params, function(data, status){
                                            //alert("Data: " + JSON.stringify(data) + "\nStatus: " + status);
                                            handleFreeTrialReqResponse(data);
                                        });
        }
    }
    
    function handleFreeTrialReqResponse(data) {
        alert(data[0].status);
        closeFreeTrialOverlay();
    }
    
    function closeFreeTrialOverlay(){
        $("#overlay-freetrial").hide();
    }
    
    
    function renderOverlayForTnC () {
        var docHeight = $(document).height();
        $("body > #overlay-tnc").css( "height", docHeight);
        $("body > #overlay-tnc").show();
    }
    
    
    function renderOverlayForCopyrightPolicy () {
        var docHeight = $(document).height();
        $("body > #overlay-copyright").css( "height", docHeight);
        $("body > #overlay-copyright").show();
    }
    
    
    function renderLAROverlay (reportLink) {
        var docHeight = $(document).height();
        $("#overlay-lar").css( "height", docHeight);
        $("#overlay-lar").show();
    }
    
    function closeLAROverlay(){
        $("#overlay-lar").hide();
    }
    var msgDisplayStartTime = new Date().getTime();
    var msgDisplayDuration = 3000;
    function renderMessageOverlay (message) {
        if (typeof message !== 'undefined' && message != null && message.trim().length > 0) {
            $("#overlay-msg > div > p").text(message.trim());
            $("#overlay-msg").show();
            msgDisplayStartTime = new Date().getTime();
            setTimeout(closeMessageOverlay, msgDisplayDuration);
        }
    }
    function closeMessageOverlay(){
        var currTime = new Date().getTime();
        var timeLapsed = currTime - msgDisplayStartTime;
        if (timeLapsed >= msgDisplayDuration) $("#overlay-msg").fadeOut(msgDisplayDuration);
        else setTimeout(closeMessageOverlay, (msgDisplayDuration-(currTime - msgDisplayStartTime)));
        return;
    }

function signout() {
    var r = confirm('Click on OK to sign out, CANCEL to close this box');
    if (r == true) {
        
        $("#signinout").prop("onclick", null); // http://stackoverflow.com/questions/1687790/how-to-remove-onclick-with-jquery
        $("#signinout").on('click', function(){
          signin();
        });
        $("#signinout").html('<span style="cursor: pointer;" onclick="signin();" data-toggle="tooltip" Title="Sign in to access all content.">Sign In</span><!-- | <span style="cursor: pointer;" onclick="javascript:renderFreeTrialOverlay();">Free Trial</span>-->');
        $("#signinout").css( 'cursor', 'pointer' );

        //alert(document.cookie);
        document.cookie = "LIAccessToken=; expires=Thu, 01 Jan 1970 00:00:00 UTC; path=/";
        //alert(document.cookie);
        //alert(window.location.href);
        location.reload(); // reload the page
        event.stopPropagation(); // required as this will also trigger click on the parent span element
        // Trigger the fetchReportData
        //fetchReportData();
    }
}

function signin() {
    //window.location.href = window.location.href + (window.location.href.indexOf('?') > 0 ? '&' : '?') + 'authenticate=true';
    //alert(window.location.href);
    var paramIdx = window.location.href.indexOf('?');
    if (paramIdx > 0){
        //alert(window.location.href.substring(0, paramIdx));
        //alert(window.location.href.substring(paramIdx, window.location.href.length));
        window.location.href = window.location.href.substring(0, paramIdx) + '?authenticate=true&' + window.location.href.substring(paramIdx+1, window.location.href.length);
    } else
        window.location.href = window.location.href + '?authenticate=true';
}

var chartColors = {};
var colorCount = 0;
function getChartColor (brand, primarybrand, intrabrandcat, intrabrandcatval) {

    var chartColor;
    var colorObj = chartColors[brand];
    if (typeof colorObj === 'undefined') {
        colorObj = {};
        if (brand == primarybrand) colorObj.color = reportColors[1];
        else {
            colorObj.color = reportColors[2+colorCount];
            colorCount++;
        }
        colorObj.intrabrands = {};
        chartColors[brand] = colorObj;
    }

    if (intrabrandcat) {
        var intrabrand = colorObj.intrabrands[intrabrandcat];
        if (typeof intrabrand === 'undefined') {
            intrabrand = {};
            colorObj.intrabrands[intrabrandcat] = intrabrand;
            intrabrand.lighten = -40;
            intrabrand.objs = {};
        }
        
        var intrabrandobj = intrabrand.objs[intrabrandcatval];
        if(typeof intrabrandobj === 'undefined') {
            intrabrandobj = {};
            intrabrand.objs[intrabrandcatval] = intrabrandobj;
            intrabrandobj.color = LightenDarkenColor(colorObj.color, intrabrand.lighten);
        }
        chartColor = intrabrandobj.color;
        intrabrand.lighten = intrabrand.lighten + 10;
        if (intrabrand.lighten == 90) intrabrand.lighten = -35; // TODO this is hack
        if (intrabrand.lighten == 85) intrabrand.lighten = -40;
    } else {
        chartColor = colorObj.color;
    }

    return chartColor;
}

function LightenDarkenColor(color, percent) { // http://www.hexcolortool.com/
    
    if (color[0] == "#") color = color.slice(1);

    var num = parseInt(color,16),
        amt = Math.round(2.55 * percent),
        R 	= (num >> 16) + amt,
        B 	= (num >> 8 & 0x00FF) + amt,
        G 	= (num & 0x0000FF) + amt;
    
    return "#" + ((0x1000000 + (R<255?R<1?0:R:255)*0x10000 + (B<255?B<1?0:B:255)*0x100 + (G<255?G<1?0:G:255)).toString(16).slice(1));
    
}