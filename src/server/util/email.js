/* emailClient object */

// Load config from the global Alphonso module
var conf, sendmail;

/* 
options = {  
            "enabled":false,
            "sender":"Alphonso Inc. <insights@alphonso.tv>",
            "notify": {  
                        "ongetreports":'',
                        "onsignin":'',
                        "onreportvideo":'',
                        "ongetfullaccess":''
            }
};
*/
module.exports = function(options) {
    console.log(JSON.stringify(options));
    var email = options;
    
    // instantiates the objects from Alphonso Platform only if send email is enabled.
    if (email.enabled) {
        conf = require('config');
        conf.set('mail.from', email.sender);
        sendmail = require('mail/mail')();
    }

    /*
    reportDetails = {
                        toAddress: '<to address>',
                        attachments : [{
                                        fileName : '<attachment name>',
                                        filePath : '<full path on disk, including filename>'
                        }];
                        header: '<brand name / content title>',
                        signininfo: 'Firstname Lastname (email)'
    };
    */
    email.sendReport = function (reportDetails) {
        console.log(JSON.stringify(reportDetails));
        
        var subject = 'Report for ' + reportDetails.header;
        var emailBody = 'Hi,<br /><br />The report, that you had requested for, can be downloaded by clicking on the link below. Alternatively you can copy/paste the link on the browser to download the report.<br /><br />' +
                        reportDetails.reportsurl + '<br /><br />' +
                        'If you have any questions, or you are looking for additional analytics, do reach out to us at insights@alphonso.tv.<br /><br />' +
                        reportDetails.extraMessage + 'With best regards,<br />The Alphonso Crew<br />www.alphonso.tv<br />';
        console.log(subject);
        console.log(emailBody);
        if (email.enabled) {
            //sendmail (reportDetails.toAddress, subject, null, null, emailBody, reportDetails.attachments);
            sendmail (reportDetails.toAddress, subject, null, null, emailBody);
            
            // TODO: implement 'bcc' in the Alphonso Platfrom mail lib.
            subject = subject + ': ' + reportDetails.toAddress;
            emailBody = 'This report was sent to: ' + reportDetails.toAddress + '<br />' +
                        'IP address: ' + reportDetails.reqIP + '<br />' +
                        'sign in information: ' + reportDetails.signininfo + '<br />' +
                        'timestamp: ' + new Date() + '<br /><br />' +
                        emailBody;
            //sendmail (email.notify.ongetreports, subject, null, null, emailBody, reportDetails.attachments);
            sendmail (email.notify.ongetreports, subject, null, null, emailBody);
        }
    }

    email.sendLARReportNotification = function (reportDetails) {
        console.log(JSON.stringify(reportDetails));
        
        var subject = "Your Location Attribution Report '" + reportDetails.report_name + "'";
        var emailBody = 'Hi,<br /><br />The report, that you had requested for, can be viewed by clicking on the link below. Alternatively you can copy/paste the link on the browser to view the report.<br /><br />' +
                        reportDetails.reportsurl + '<br /><br />' +
                        'If you have any questions, or you are looking for additional analytics, do reach out to us at insights@alphonso.tv.<br /><br />' +
                        'With best regards,<br />The Alphonso Crew<br />www.alphonso.tv<br />';
        if (reportDetails.isValid == 0)
            emailBody = 'Hi,<br /><br />We noticed that the report you requested has fewer data points than what we normally recommend for a robust analysis.<br /><br />' +
                        'You may want to try expanding the date range for your report and re-run the analysis.<br /><br />' +
                        'Or just send us a note at insights@alphonso.tv and our team will be happy to help you through your analysis.<br /><br />' +
                        'With best regards,<br />The Alphonso Crew<br />www.alphonso.tv<br />';
        console.log(subject);
        console.log(emailBody);
        if (email.enabled) {
            sendmail (reportDetails.toAddress, subject, null, null, emailBody);
        }
    }

    /*
    details = {
                video: {
                    contentid: '<content id>',
                    contenttitle: '<content title>',
                    videourl: '<video url>',
                    dashboardurl: '<dashboard details page url>'
                },
                reportedby: {
                    name: '<name>',
                    email: '<email address>',
                    company: '<company name>',
                    phone: '<phone number>',
                    desc: '<description>'
                },
                signininfo: 'Firstname Lastname (email)'
    };
    */
    email.reportVideo = function (details) {
        console.log(JSON.stringify(details)); // TODO put TS
        
        var subject = 'Video Reported Alert: ' + details.video.dashboardurl;
        var emailBody = 'Hi,<br /><br />' +
        
                        'Following video has been reported,<br />' +
                        'timestamp: ' + new Date() + '<br />' +
                        'content id: '+ details.video.contentid + '<br />' +
                        //'content title: ' + details.video.contenttitle + '<br />' +
                        //'video url: ' + details.video.videourl + "<br />" +
                        'dashboard url: ' + details.video.dashboardurl + '<br /><br />' +
                        
                        'Other reported information,<br />' +
                        'Name: ' + details.reportedby.name + '<br />' +
                        'Email Address: ' + details.reportedby.email + '<br />' +
                        'Company Name: ' + details.reportedby.company + '<br />' +
                        'Phone Number: ' + details.reportedby.phone + '<br />' +
                        'Description: ' + details.reportedby.desc + '<br /><br />' +
                        
                        'IP address: ' + details.reqIP + '<br />' +
                        'Sign in information: ' + details.signininfo + '<br /><br />' +
                        
                        'With best regards,<br />The Alphonso Crew<br />www.alphonso.tv<br />';
        console.log(subject);
        console.log(emailBody);
        if (email.enabled) {
            sendmail (email.notify.onreportvideo, subject, null, null, emailBody, null);
        }
                        
    }

    /*
    details = {
                email: '<email address>',
                signininfo: 'Firstname Lastname (email)'
    };
    */
    email.requestFT = function (details) {
        console.log(JSON.stringify(details)); // TODO put TS
        
        var subject = 'Free Trial Request Alert: ' + details.email;
        var emailBody = 'Hi,<br /><br />' +
        
                        'Free trial request received,<br />' +
                        'timestamp: ' + new Date() + '<br />' +
                        'Email Address: ' + details.email + '<br />' +
                        'Brands of interest: ' + details.brands + '<br />' +
                        'IP address: ' + details.reqIP + '<br />' +
                        'Sign in information: ' + details.signininfo + '<br /><br />' +
                        
                        'With best regards,<br />The Alphonso Crew<br />www.alphonso.tv<br />';
        console.log(subject);
        console.log(emailBody);
        if (email.enabled) {
            sendmail (email.notify.onftrequest, subject, null, null, emailBody, null);
        }
                        
    }

    /*
    details = {
                signininfo: {
                    firstname: '<firstname>',
                    lastname: '<lastname>',
                    email: '<email address>',
                    picture: '<picture url>'
                },
                content: {
                    contentid: '<content id>',
                    contenttitle: '<content title>',
                    brand: '<brand>',
                    category: '<category>',
                    dashboardurl: '<dashboard details page url>'
                }
    };
    */
    email.signInAlert = function (details) {
        console.log(JSON.stringify(details));
        
        var subject = 'Sign In Alert: ' + details.signininfo.firstname + ' ' + details.signininfo.lastname + ' (' + details.signininfo.email + ')';
        var emailBody = 'The following person has signed in.<br /><br />' +
                        'Timestamp: ' + new Date() + '<br />' +
                        'IP address: ' + details.reqIP + '<br />' +
                        'First Name: ' + details.signininfo.firstname + '<br />' + 
                        'Last Name: ' + details.signininfo.lastname + '<br />' +
                        'Email: ' + details.signininfo.email + '<br />' +
                        'Picture url: ' + details.signininfo.picture + '<br />' +
                        'URL accessed: ' + details.content.dashboardurl + '<br /><br />' +
                        //details.content.category + ' > ' + details.content.brand + ' > [' + details.content.contentid + '] ' + details.content.contenttitle + '<br /><br />' +
                        'With best regards,<br />The Alphonso Crew<br />www.alphonso.tv<br />';
        console.log(subject);
        console.log(emailBody);
        if (email.enabled) {
            sendmail (email.notify.onsignin, subject, null, null, emailBody, null);
        }
                        
    }

    return email;
};