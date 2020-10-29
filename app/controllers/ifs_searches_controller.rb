# frozen_string_literal: true

class IfsSearchesController < ApplicationController
  load_and_authorize_resource
  skip_authorize_resource only: :uuid
  skip_authorization_check only: :uuid
  before_action :set_ifs_search, only: [:show, :edit, :update, :destroy]

  # GET /ifs_searches
  # GET /ifs_searches.json
  def index
    @user = current_user
    if @user.admin?
      @ifs_searches = IfsSearch.all
    else
      @ifs_searches = @user.ifs_search
    end
  end

  # GET /ifs_searches/1
  # GET /ifs_searches/1.json
  def show
    @results = @ifs_search.ifs_search_results
    @results = @results.group_by(&:column).sort.to_h.map { |k, v| v.sort_by(&:row) }
    # binding.pry
  end

  def uuid
    @ifs_search = IfsSearch.find_by(uuid: params[:uuid])
    self.show
    if @results
      render "ifs_searches/show"
    end
  end

  # GET /ifs_searches/new
  def new
    @ifs_search = IfsSearch.new
  end

  # GET /ifs_searches/1/edit
  def edit
  end

  # POST /ifs_searches
  # POST /ifs_searches.json
  def create
    @ifs_search = IfsSearch.new(ifs_search_params.merge(uuid: SecureRandom.uuid))

    respond_to do |format|
      if @ifs_search.save
        @ifs_search.delay.split_image
        format.html { redirect_to ifs_searches_path, notice: "Ifs search was successfully created." }
        format.json { render :show, status: :created, location: @ifs_search }
      else
        format.html { render :new }
        format.json { render json: @ifs_search.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /ifs_searches/1
  # PATCH/PUT /ifs_searches/1.json
  def update
    respond_to do |format|
      if @ifs_search.update(ifs_search_params)
        format.html { redirect_to @ifs_searches_path, notice: "Ifs search was successfully updated." }
        format.json { render :show, status: :ok, location: @ifs_search }
      else
        format.html { render :edit }
        format.json { render json: @ifs_search.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /ifs_searches/1
  # DELETE /ifs_searches/1.json
  def destroy
    @ifs_search.destroy
    respond_to do |format|
      format.html { redirect_to ifs_searches_url, notice: "Ifs search was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_ifs_search
      @ifs_search = IfsSearch.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def ifs_search_params
      params.fetch(:ifs_search, {}).permit(:title, :request, :user_id).merge(user_id: current_user.id)
    end
end
