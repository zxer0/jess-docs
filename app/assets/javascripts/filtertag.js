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


function filter() {
    $.xhrPool.abortAll();
    var formElem = $('#tag-form');
    var formParams = "?" + formElem.serialize();
    var currentState = {params: formParams}
    history.pushState({params: formParams}, "", formParams);
    
    
    formElem.submit();
}

function getProjectId(){
    return $('#project-select').val();
}