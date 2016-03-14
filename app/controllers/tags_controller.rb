class TagsController < ApplicationController
  before_action :set_tag, only: [:show, :edit, :update, :destroy]

  # GET /tags
  # GET /tags.json
  def index
    @tags = Tag.all
  end

  # GET /tags/1
  # GET /tags/1.json
  def show
  end

  # GET /tags/new
  def new
    @tag = Tag.new
    @tag_types = TagType.all
    @spec = Spec.find(params[:id])
    @spec_tags = @spec.tags.pluck(:tag_type_id)
  end

  # GET /tags/1/edit
  def edit
  end

  # POST /tags
  # POST /tags.json
  def create
    @spec = Spec.find(params[:spec_id])
    @tags = @spec.tags
    @tag_types = TagType.all
    
    unless params[:tag_types]
      @tags.destroy_all
    else
      current_tag_types = @tags.pluck(:tag_type_id)
      tag_types_to_delete = current_tag_types - params[:tag_types]
      tag_types_to_add = params[:tag_types] - current_tag_types
      @tags.where(:tag_type_id => tag_types_to_delete).destroy_all
      tag_types_to_add.each do |tag_type|
        Tag.create!(:spec_id => @spec.id, :tag_type_id => tag_type)
      end
    end
    @new_tags_hash = @spec.tags ? @spec.tags.to_a.map(&:to_hash) : nil
  end

  # PATCH/PUT /tags/1
  # PATCH/PUT /tags/1.json
  def update
    respond_to do |format|
      if @tag.update(tag_params)
        format.html { redirect_to @tag, notice: 'Tag was successfully updated.' }
        format.json { render :show, status: :ok, location: @tag }
      else
        format.html { render :edit }
        format.json { render json: @tag.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /tags/1
  # DELETE /tags/1.json
  def destroy
    @tag.destroy
    respond_to do |format|
      format.html { redirect_to '/specs', notice: 'Tag was successfully destroyed.' }
      format.json { head :no_content }
      format.js   { render :layout => false }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_tag
      @tag = Tag.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def tag_params
      params.require(:tag).permit(:tag_type_id, :spec_id)
    end
    
    def new_tag_params
      params.require(:spec_id)
    end
    
end
