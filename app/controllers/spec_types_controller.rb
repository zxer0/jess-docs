class SpecTypesController < ApplicationController
  before_action :set_spec_type, only: [:show, :edit, :update, :destroy]

  # GET /spec_types
  # GET /spec_types.json
  def index
    @spec_types = SpecType.all
  end

  # GET /spec_types/1
  # GET /spec_types/1.json
  def show
  end

  # GET /spec_types/new
  def new
    @spec_type = SpecType.new
  end

  # GET /spec_types/1/edit
  def edit
  end

  # POST /spec_types
  # POST /spec_types.json
  def create
    @spec_type = SpecType.new(spec_type_params)

    respond_to do |format|
      if @spec_type.save
        format.html { redirect_to @spec_type, notice: 'Spec type was successfully created.' }
        format.json { render :show, status: :created, location: @spec_type }
      else
        format.html { render :new }
        format.json { render json: @spec_type.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /spec_types/1
  # PATCH/PUT /spec_types/1.json
  def update
    respond_to do |format|
      if @spec_type.update(spec_type_params)
        format.html { redirect_to @spec_type, notice: 'Spec type was successfully updated.' }
        format.json { render :show, status: :ok, location: @spec_type }
      else
        format.html { render :edit }
        format.json { render json: @spec_type.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /spec_types/1
  # DELETE /spec_types/1.json
  def destroy
    @spec_type.destroy
    respond_to do |format|
      format.html { redirect_to spec_types_url, notice: 'Spec type was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_spec_type
      @spec_type = SpecType.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def spec_type_params
      params[:spec_type]
    end
end
