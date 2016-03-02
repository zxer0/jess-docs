$(document).ready(function () {
    $(".spec").hover(function () {
       $('.edit-button', this).css('visibility','visible');
    }, function() {
       $('.edit-button', this).css('visibility','hidden');
    });
    
    $('.edit-button').click( function() {
        var btnElem = $(this).parent().next('.spec-buttons').first();
        $('.spec-buttons').removeClass('in');
        btnElem.collapse('toggle');
       
    });
    
});

function toggleTagEdit() {
    var tagElem = $('.delete_tag')
    if ( tagElem.hasClass('hidden')){
        tagElem.removeClass('hidden');
    }
    else {
        tagElem.addClass('hidden');
    }
}