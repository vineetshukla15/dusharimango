module.exports = function(request) {
    var cookies = {};
    request.headers.cookie && request.headers.cookie.split(';').forEach(function (cookie) {
        var parts = cookie.split('=');
        cookies[ parts[ 0 ].trim() ] = (parts[ 1 ] || '').trim();
    });
    
    return cookies;
}