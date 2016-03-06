class SpecsController < ApplicationController
  # before_action :set_spec, only: [:show, :edit, :update, :destroy]
  before_action :initialize_tags, only: [ :index, 
                                          :filter_project, 
                                          :filter_tag, 
                                          :mass_add_view,
                                          :mass_add,
                                          :create,
                                          :dedent,
                                          :indent]
  
  # GET /specs
  # GET /specs.json
  def index
    @filtered_spec_ids = Spec.pluck(:id)
    @projects = Project.all
    @selected_project_id = params[:project_id] || Project.first.id
  
    @specs = get_spec_hash(Spec.for_project(@selected_project_id))
    
    @tag_types = TagType.all
    
  end
  
  def filter_project
    @projects = Project.all
    # filtered_specs = Spec.all
    
    # if filter_params.any?
    @selected_project_id = filter_project_params[:project_id] || Projects.first.id
    @project = Project.find(@selected_project_id)
    
    # filtered_specs = Spec.filter_by_project(@selected_project_id)
    
    @specs = get_spec_hash(Spec.for_project(@selected_project_id))
    
    respond_to do |format|
      format.html
      format.js { render :layout => false }
    end
  end
  
  def filter_tag
    project_id = params[:project_id]
    @tag_types = TagType.all
    @project = Project.find(project_id)
    
    @specs = get_spec_hash(Spec.for_project(project_id))
    
    @projects = Project.all
    
    @filtered_spec_ids_array = []
    
    
    @tag_type_ids = params[:tag_types]
    
    if @tag_type_ids
      @tag_type_ids.each do |tag_type_id|
        # @filtered_spec_ids_array << Spec.filter_by_tag_type(tag_type_id, @project_specs).map(&:id).uniq
        @filtered_spec_ids_array << Spec.all_ancestry_ids(Spec.for_project(@project.id).with_tag_type(tag_type_id))
      end
    end
    
    @ticketed = params[:ticketed]
    if @ticketed
      @filtered_spec_ids_array << Spec.all_ancestry_ids(Spec.for_project(@project.id).has_ticket)
    end
    
    @filtered_spec_ids = @filtered_spec_ids_array.inject(:&)
    
    if @filtered_spec_ids
      @filtered_spec_ids.uniq!
    end
    
    respond_to do |format|
      format.html
      format.js { render :layout => false }
    end
  end

  # GET /specs/1
  # GET /specs/1.json
  def show
     @spec = Spec.find(params[:id])
  end

  # GET /specs/new
  def new
    if params[:project_id]
      @selected_project_id = params[:project_id]
    end
    @spec_types = SpecType.all
    @projects = Project.all
    
    if params[:id]
      if params[:add_child]
        @parent = Spec.find(params[:id])
        @spec = @parent.children.new
      else
        @spec = Spec.new
        @spec_types = SpecType.where.not(:name => 'it')
        @child = Spec.find(params[:id])
      end
    else
      @spec = Spec.new
    end
  end

  # GET /specs/1/edit
  def edit
    @projects = Project.all
    @spec = Spec.find(params[:id])
    @spec_types = SpecType.all
    
  end

  # POST /specs
  # POST /specs.json
  def create
    @spec = Spec.create(spec_params)
    @projects = Project.all
    
    if params[:spec][:child_id]
      @child_id = params[:spec][:child_id]
      @child = Spec.find(params[:spec][:child_id])
    end
    
    if @spec.save
      if params[:spec][:child_id]
        @spec.update!(:parent => @child.parent)
        @child.update!(:parent => @spec)
      end
      
      if spec_params[:parent_id]
        @print_specs_hash = @spec.parent.subtree.arrange_serializable do |parent, children|
          parent.to_hash.merge({ :children => children})
        end
      else
        @print_specs_hash = @spec.subtree.arrange_serializable do |parent, children|
          parent.to_hash.merge({ :children => children})
        end
      end
      
      # redirect_to :action => 'index'
    else
      @spec_types = SpecType.all
      render :action => 'new'
    end
     
  end

  # PATCH/PUT /specs/1
  # PATCH/PUT /specs/1.json
  def update
    @spec = Spec.find(params[:id])
	  
	  
    if @spec.update_attributes(spec_param)
      # redirect_to :action => 'index', :id => @spec
    else
      @spec_types = SpecType.all
      render :action => 'edit'
    end
  end
  
  #GET /specs/mass_add_view
  def mass_add_view
    @projects = Project.all
    
    if params[:id]
      @parent_id = params[:id]
      @parent = Spec.find(@parent_id)
      
      @print_specs_hash = @parent.to_hash
      # @print_specs_hash = @parent.arrange_serializable do |parent, children|
      #   parent.to_hash.merge({ :children => children})
      # end
    end
  end
  
  #POST /specs/mass_add
  def mass_add
    # @projects = Project.all
    parent_id = params[:project][:parent_id]
    @current_project_id = params[:project][:id]
    
    Spec.parse_block(params[:text], @current_project_id, parent_id)
    # @specs = Spec.for_project(params[:project][:id]).roots
    
    @print_specs_hash = get_spec_hash(Spec.for_project(@current_project_id))
    # redirect_to :action => 'index'
  end

  #POST /specs/:spec_id/indent
  def indent
    @spec = Spec.find(params[:spec_id])
    @closest_older_sibling_id = @spec.closest_older_sibling_id
    
    if @spec.update(:parent => Spec.find(@closest_older_sibling_id))
      @print_specs_hash = get_spec_hash(Spec.find(@closest_older_sibling_id).subtree)
      # redirect_to :action => 'index', :id => @spec
    else
      
    end
  end
  
  #POST /specs/:spec_id/dedent
  def dedent
    @spec = Spec.find(params[:spec_id])
   
    @old_parent_id = @spec.parent.id
    @new_parent = @spec.parent.parent
    
    if @spec.update(:parent => @new_parent)
      if @new_parent
        @print_specs_hash = get_spec_hash(@new_parent.subtree)
      else
        @print_specs_hash = get_spec_hash(@spec.subtree)
      end
  
      # redirect_to :action => 'index', :id => @spec
    else
      
    end
  end
  
  def delete
    @tag_hash = tag_hash
    @ticket_hash = ticket_hash
    @spec = Spec.find(params[:spec_id])
    
     @deleted_specs = @spec.subtree.arrange_serializable do |parent, children|
      parent.to_hash.merge({ :children => children})
    end
    
  end

  # DELETE /specs/1
  # DELETE /specs/1.json
  def destroy
    @spec = Spec.find(params[:id])
    
    deleted_id = params[:id]

    @spec.destroy
  
    respond_to do |format|
      format.html { redirect_to specs_url, notice: 'Spec was successfully destroyed.' }
      format.json { head :no_content }
      format.js   { render :layout => false, 
                    :locals => {:deleted_id => deleted_id} }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    # def set_spec
    #   @spec = Spec.find(params[:id])
    # end
    
    def initialize_tags
      @tag_hash = tag_hash
      @ticket_hash = ticket_hash
    end
    
    def get_spec_hash(spec_scope)
      hash = spec_scope.arrange_serializable(:order => 'created_at ASC') do |parent, children|
        parent.to_hash.merge({ :children => children})
      end
      
      hash
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def spec_params
      params.require(:spec).permit(:description, :spec_type_id, :parent_id, :project_id)
    end
  
    def spec_param
      params.require(:spec).permit(:description, :spec_type_id, :project_id)
    end
    
    def mass_add_params
      params.require(:text, :projects).permit(:project_id)
    end
    
    def filter_params
      filter_params = {}
      if params 
        if params[:tags] && params[:tags][:tag_type_id] != ""
          params.require(:tags).require(:tag_type_id)
          filter_params[:tag_type_id] = params[:tags][:tag_type_id]
        end
        if params[:projects] && params[:projects][:project_id] != ""
          params.require(:projects).require(:project_id)
          filter_params[:project_id] = params[:projects][:project_id]
        end
      end
      
      filter_params
    end
    
    def filter_project_params
      params.require(:projects).permit(:project_id)
    end
    
    def filter_tag_params
      
      params.require(:project_id)
    end
    
    def show_spec_types
      @spec_type = SpecType.find(params[:id])
    end
    
    def tag_hash
      tag_hash = Hash.new { |h,k| h[k] = [] }
      Tag.joins(:tag_type).pluck(:spec_id, :id, :name, :color).map do |tag| 
        if tag_hash[tag.first]
          tag_hash[tag.first] << {
            :id => tag[1],
            :name => tag[2],
            :color => tag[3]
          }
        else
          tag_hash.merge( [tag.first,  {
            :id => tag[1],
            :name => tag[2],
            :color => tag[3]
          } ] ) 
        end
      end
      tag_hash
    end
    
    def ticket_hash
      ticket_hash = Hash.new { |h,k| h[k] = [] }
      Ticket.pluck(:spec_id, :id, :tracker_id, :name).map do |ticket| 
        if ticket_hash[ticket.first]
          ticket_hash[ticket.first] << {
            :id => ticket[1],
            :tracker_id => ticket[2],
            :url => Ticket.get_url(ticket[2]),
            :name => ticket[3]
          }
        else
          ticket_hash.merge( [ticket.first,  {
            :id => ticket[1],
            :tracker_id => ticket[2],
            :url => Ticket.get_url(ticket[2]),
            :name => ticket[3]
          } ] ) 
        end
      end
      ticket_hash
    end
end
