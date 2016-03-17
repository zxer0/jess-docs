$(document).ready(function () {
    
    $(document).on("ajax:success", "form", function() {
        $("#spec-modal").modal("hide");
        updateState();
    });
    
    $(document).on('click','.indent_spec', function(){
        updateState();
    });
    
});

function updateState(){
    var currentState = location.search;
    $.getScript("/specs/filter_tag.js" + currentState)
}