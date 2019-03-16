$(document).ready(function() {
    navigator.sayswho= (function(){
        var ua= navigator.userAgent, tem,
            M= ua.match(/(opera|chrome|safari|firefox|msie|trident(?=\/))\/?\s*(\d+)/i) || [];
        if(/trident/i.test(M[1])){
            tem=  /\brv[ :]+(\d+)/g.exec(ua) || [];
            return 'IE '+(tem[1] || '');
        }
        if(M[1]=== 'Chrome'){
            tem= ua.match(/\bOPR\/(\d+)/);
            if(tem!= null) return 'Opera '+tem[1];
        }
        M= M[2]? [M[1], M[2]]: [navigator.appName, navigator.appVersion, '-?'];
        if((tem= ua.match(/version\/(\d+)/i))!= null) M.splice(1, 1, tem[1]);
        return M.join(' ');
    })();

    var browser = navigator.sayswho.split(" ");
    browser_name = browser[0];
    browser_version = browser[1];

    switch(browser_name.toLowerCase()) {
        case "chrome":
            if(browser_version < 14) {
                $("#browserModal #browserContent").html("Your browser is Chrome.  The version is " + browser_version + ". This is an older version of Chrome and may cause performance issues with Safety Notice. To assure a positive user experience, please click on this <b><a href='http://www.google.com/chrome/browser/desktop/' target='_blank'>link</a></b> to update your browser to the current version.");
                show_browser_update();
                break;
            }
        case "msie":
            if(browser_version < 11) {
                $("#browserModal #browserContent").html("Your browser is Internet Explorer.  The version is " + browser_version + ". This is an older version of Internet Explorer and may cause performance issues with Safety Notice. To assure a positive user experience, please click on this <b><a href='http://windows.microsoft.com/en-GB/internet-explorer/download-ie' target='_blank'>link</a></b> to update your browser to the current version.");
                show_browser_update();
                break;
            }
        case "firefox":
            if(browser_version < 10) {
                $("#browserModal #browserContent").html("Your browser is Firefox.  The version is " + browser_version + ". This is an older version of Firefox and may cause performance issues with Safety Notice. To assure a positive user experience, please click on this <b><a href='https://www.mozilla.org/en-US/firefox/new/' target='_blank'>link</a></b> to update your browser to the current version.");
                show_browser_update();
                break;
            }
        default:
            console.log("No Browser Matched");

    }

    function show_browser_update(){
        if(jQuery.cookie("browser_alert") == "true"){
            $('#browserModal').modal({backdrop: 'static', keyboard: false, show: true});
        }
    }
    //function centerModals(modal){
    //    //$('.modal').each(function(i){
    //    var $clone = $(modal).clone().css('display', 'block').appendTo('body');
    //    var top = Math.round(($clone.height() - $clone.find('.modal-content').height()) / 2);
    //    top = top > 0 ? top : 0;
    //    $clone.remove();
    //    $(modal).find('.modal-content').css("margin-top", top);
    //    //});
    //}
    //centerModals($('#browserModal'));
    //$(window).on('resize', centerModals($('#browserModal')));
});