$(document).ready(function () {
     
 
    if ($(".requests-badge").length > 0) {
        setTimeout(updateRequestsBadge, 10000);
    }
    
    function updateRequestsBadge () {
        var requestNum = $('.requests-badge').first().text();
        
        $.getScript("/requests/poll.js")
        setTimeout(updateRequestsBadge, 10000);
    }
    
});