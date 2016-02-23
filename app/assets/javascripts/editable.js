function toggleTagEdit() {
    var tagElem = $('.delete_tag')
    if ( tagElem.hasClass('hidden')){
        tagElem.removeClass('hidden');
    }
    else {
        tagElem.addClass('hidden');
    }
}