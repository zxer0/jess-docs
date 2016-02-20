class SpecsController < ApplicationController
  # before_action :set_spec, only: [:show, :edit, :update, :destroy]

  # GET /specs
  # GET /specs.json
  def index
    @filtered_spec_ids = nil
    
    if filter_params
      @selected_tag_type_id = filter_params 
      @filtered_spec_ids = Spec.filter(@selected_tag_type_id).map(&:id) 
    else
     
    end
    @specs = Spec.get_top_level(Spec.all)
    
    puts "filtered_spec_ids = #{@filtered_spec_ids}"
    @tag_types = TagType.all
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
    @spec = Spec.new
    @spec_types = SpecType.all
    if params[:id]
      if params[:add_child]
        @parent = Spec.find(params[:id])
      else
        @spec_types = SpecType.where.not(:name => 'it')
        @child = Spec.find(params[:id])
      end
    end
  end

  # GET /specs/1/edit
  def edit
    @spec = Spec.find(params[:id])
    @spec_types = SpecType.all
  end

  # POST /specs
  # POST /specs.json
  def create
    @spec = Spec.new(spec_params)
    if params[:spec][:child_id]
      @child = Spec.find(params[:spec][:child_id])
    end
    
    if @spec.save
      if params[:spec][:child_id]
        @spec.update!(:parent_id => @child.parent_id)
        @spec.children << @child
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

  # DELETE /specs/1
  # DELETE /specs/1.json
  def destroy
    @spec = Spec.find(params[:id])
    
    new_parent_id = @spec.parent_id
    if !new_parent_id.nil?
      @parent = Spec.find(new_parent_id)
    end
    
    oldest_parent = @spec.oldest_parent
    only_child = @spec.only_child?
    
    #won't somebody please think of the children
    @spec.children.each do |child|
      child.update!(:parent_id => new_parent_id)
    end
    
    @spec.destroy
    
    respond_to do |format|
      format.html { redirect_to specs_url, notice: 'Spec was successfully destroyed.' }
      format.json { head :no_content }
      format.js   { render :layout => false, 
                    :locals => {:oldest_parent => oldest_parent, 
                                :only_child => only_child} }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    # def set_spec
    #   @spec = Spec.find(params[:id])
    # end

    # Never trust parameters from the scary internet, only allow the white list through.
    def spec_params
      params.require(:spec).permit(:description, :spec_type_id, :parent_id)
    end
  
    
    def spec_param
      params.require(:spec).permit(:description, :spec_type_id)
    end
    
    def filter_params
      if params && params[:tags] && params[:tags][:tag_type_id] != ""
        params.require(:tags).require(:tag_type_id)
        return params[:tags][:tag_type_id]
      end
      nil
    end
    
    def show_spec_types
      @spec_type = SpecType.find(params[:id])
    end
    
end
