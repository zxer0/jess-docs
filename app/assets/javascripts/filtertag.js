function addProject() {
    var project_id = $('#project-select').val();
    var hidden_field = $("#hidden_project_id");
    if(hidden_field.length ===0){
        $('#tag-form').append('<input type="hidden" id="hidden_project_id" name="project_id" value="' + project_id +'" /> ');
    }
    else {
        hidden_field.replaceWith('<input type="hidden" id="hidden_project_id" name="project_id" value="' + project_id +'" /> ')
    }
    
}