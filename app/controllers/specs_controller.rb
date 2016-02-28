class SpecsController < ApplicationController
  # before_action :set_spec, only: [:show, :edit, :update, :destroy]
  
  
  # GET /specs
  # GET /specs.json
  def index
    @filtered_spec_ids = Spec.all.map(&:id)
    @projects = Project.all
    @selected_project_id = Project.first.id
    
  
    @specs = Spec.roots.for_project(@selected_project_id)
    
    @tag_types = TagType.all
    
  end
  
  def filter_project
    @projects = Project.all
    # filtered_specs = Spec.all
    
    # if filter_params.any?
    @selected_project_id = filter_project_params[:project_id] || Projects.first.id
    @project = Project.find(@selected_project_id)
    
    # filtered_specs = Spec.filter_by_project(@selected_project_id)
      
    # end
    @specs = Spec.roots.for_project(@selected_project_id) #Spec.get_top_level(filtered_specs)
    
    respond_to do |format|
      format.html
      format.js { render :layout => false }
    end
  end
  
  def filter_tag
    project_id = params[:project_id]
    @tag_types = TagType.all
    @project = Project.find(project_id)
    @specs = Spec.for_project(project_id).roots
    # @project_specs = Spec.for_project(@project.id)
    # @filtered_spec_ids = @project_specs.map(&:id)
    @projects = Project.all
    
    @filtered_spec_ids_array = []
    
    @tag_type_ids = params[:tag_types]
    
    if @tag_type_ids
      @tag_type_ids.each do |tag_type_id|
        # @filtered_spec_ids_array << Spec.filter_by_tag_type(tag_type_id, @project_specs).map(&:id).uniq
        @filtered_spec_ids_array << Spec.all_ancestry_ids(Spec.for_project(@project.id).with_tag_type(tag_type_id))
      end
      
      @filtered_spec_ids = @filtered_spec_ids_array.inject(:&).uniq
      
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
  
  def list
    @specs = Spec.all
  end

  # GET /specs/new
  def new
    
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
    @spec = Spec.new(spec_params)
    @projects = Project.all
    
    if params[:spec][:child_id]
      @child = Spec.find(params[:spec][:child_id])
    end
    
    if @spec.save
      if params[:spec][:child_id]
        @spec.update!(:parent => @child.parent)
        @child.update!(:parent => @spec)
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
  
  #GET /spec/mass_add_view
  def mass_add_view
    @projects = Project.all
  end
  
  #POST /spec/mass_add
  def mass_add
    @projects = Project.all
    Spec.parse_block(params[:text], params[:project][:id])
    @specs = Spec.for_project(params[:project][:id]).roots
    # redirect_to :action => 'index'
  end

  # DELETE /specs/1
  # DELETE /specs/1.json
  def destroy
    @spec = Spec.find(params[:id])
    
    new_parent_id = @spec.parent_id
    if !new_parent_id.nil?
      @parent = Spec.find(new_parent_id)
    end
    
    deleted_parent_id = @spec.parent_id
    parent_of_parent_id = @spec.parent.nil? ? nil : @spec.parent.parent_id
    has_children = @spec.children.any?
    deleted_id = params[:id]
    child_ids = @spec.children.map(&:id)
    
    # #won't somebody please think of the children
    # @spec.children.each do |child|
    #   child.update!(:parent_id => new_parent_id)
    # end
    
    @spec.destroy
    
    deleted_parent_children = deleted_parent_id.nil? ? nil : Spec.find(deleted_parent_id).children.map(&:id)
    
    respond_to do |format|
      format.html { redirect_to specs_url, notice: 'Spec was successfully destroyed.' }
      format.json { head :no_content }
      format.js   { render :layout => false, 
                    :locals => {:deleted_parent_id => deleted_parent_id, 
                                :has_children => has_children,
                                :deleted_id => deleted_id,
                                :parent_of_parent_id => parent_of_parent_id,
                                :child_ids => child_ids,
                                :deleted_parent_children => deleted_parent_children
                    } }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    # def set_spec
    #   @spec = Spec.find(params[:id])
    # end

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
    
end
