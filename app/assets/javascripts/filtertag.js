$.xhrPool = [];

$.xhrPool.abortAll = function() {
    $.xhrPool.forEach(function(jqXHR) { 
        jqXHR.abort(); 
    });
};

$.rails.ajax = function(options){
	var req = $.ajax(options);
	$.xhrPool.push(req);
	return req;
};

function addProject() {
    $.xhrPool.abortAll();
    
    var project_id = $('#project-select').val();
    var hidden_field = $("#hidden_project_id");
    if(hidden_field.length ===0){
        $('#tag-form').append('<input type="hidden" id="hidden_project_id" name="project_id" value="' + project_id +'" /> ');
    }
    else {
        hidden_field.replaceWith('<input type="hidden" id="hidden_project_id" name="project_id" value="' + project_id +'" /> ')
    }
    $('#tag-form').submit();
}

function filterProjects() {
    $.xhrPool.abortAll();
    
    $('.filter-project').submit();
}

function filter() {
    $.xhrPool.abortAll();
    $('#tag-form').submit();
}