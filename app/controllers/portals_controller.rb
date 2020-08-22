class PortalsController < ApplicationController
  load_and_authorize_resource
  before_action :set_portal, only: [:show, :edit, :update, :destroy]

  # GET /portals
  # GET /portals.json
  def index
    @count = Portal.count
    @portals = Portal.order(:latitude, :longitude).page(params[:page]).per(8)
  end

  # GET /portals/1
  # GET /portals/1.json
  def show
  end

  # GET /portals/new
  def new
    @portal = Portal.new
  end

  # GET /portals/1/edit
  def edit
  end

  # POST /portals
  # POST /portals.json
  def create
    if params.has_key? :capture
      @data = params.fetch(:capture, {}).map { |x| x.permit(:name, :latitude, :longitude, :url) }
      PortalBatchCreateJob.perform_later items: @data
    else
      @portal = Portal.new(portal_params)
    end

    respond_to do |format|
      if params.has_key? :capture
        format.html { render :index, notice: "Portals were pending to added." }
        format.json { render :index, status: :created }
      elsif @portal.save
        format.html { redirect_to @portal, notice: "Portal was successfully created." }
        format.json { render :show, status: :created, location: @portal }
      else
        format.html { render :new }
        format.json { render json: @portal.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /portals/1
  # PATCH/PUT /portals/1.json
  def update
    respond_to do |format|
      if @portal.update(portal_params)
        format.html { redirect_to @portal, notice: "Portal was successfully updated." }
        format.json { render :show, status: :ok, location: @portal }
      else
        format.html { render :edit }
        format.json { render json: @portal.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /portals/1
  # DELETE /portals/1.json
  def destroy
    @portal.destroy
    respond_to do |format|
      format.html { redirect_to portals_url, notice: "Portal was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_portal
      @portal = Portal.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def portal_params
      params.fetch(:portal, {})
    end
end
