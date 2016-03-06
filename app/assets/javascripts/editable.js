$(document).ready(function () {
    $(document).on('mouseenter','.spec', function(){
      $('.edit-button', this).css('visibility','visible');
    }).on('mouseleave', '.spec', function() {
        $('.edit-button', this).css('visibility','hidden');
    });  
    
    $(document).on('click','.edit-button', function(){
        var btnElem = $(this).parent().next('.spec-buttons').first();
        
        btnElem.collapse('toggle');
        var tagElem = $(this).siblings('.tags').find('.delete_tag');
        
        toggleEdit(tagElem);
        
        var ticketElem = $(this).siblings('.tickets').find('.delete_tag');
        toggleEdit(ticketElem)
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

function toggleEdit(tagElem) {
    if ( tagElem.hasClass('hidden')){
        tagElem.removeClass('hidden');
    }
    else {
        tagElem.addClass('hidden');
    }
}