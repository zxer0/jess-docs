$(document).ready(function () {
     
 
    if ($(".requests-badge").length > 0) {
        setTimeout(updateRequestsBadge, 30000);
    }
    
    function updateRequestsBadge () {
        var requestNum = $('.requests-badge').first().text();
        
        
            $.ajax({
              url: '/requests/poll',
              success: function(data){
                  updateRequestCount(data);
              },
              dataType: "text",
              global: false,
            });
        
        setTimeout(updateRequestsBadge, 30000);
    }
    
});

function updateRequestCount(data){
    var requestNum = +($('.requests-badge').first().text());
    var newRequestNum = data;
    if (newRequestNum === 0){
       newRequestNum = '';
    }
    $('.requests-badge').html(newRequestNum);
}