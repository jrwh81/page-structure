class PagesController < ApplicationController
  include StructureHelper, CsvHelper
  before_action :set_page, only: [:show, :edit, :update, :destroy]

  # GET /pages
  # GET /pages.json
  def index
    @pages = Page.all
  end

  # GET /pages/1
  # GET /pages/1.json
  def show
    @page_structure = Page.find_by(parent_path: '', csv_id: @page.csv_id).subtree.arrange
  end

  # GET /pages/new
  def new
    @page = Page.new
  end

  def create
    @page = Page.new(page_params)
    validate_csv(@page)
    respond_to do |format|
      if @page.errors.blank?
        @master_page = process_csv(@page.csv)
        format.html { redirect_to @master_page, notice: 'Page was successfully created.' }
        format.json { render :show, status: :created, location: master_page }
      else
        format.html { render :new }
        format.json { render json: @page.errors, status: :unprocessable_entity }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_page
      @page = Page.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def page_params
      params.require(:page).permit(:csv)
    end
end
