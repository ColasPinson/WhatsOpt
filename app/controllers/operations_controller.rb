class OperationsController < ApplicationController
  before_action :set_ope, only: [:show, :edit, :update, :destroy]

  # GET /operations/1
  def show
    @mda = @ope.analysis
  end
  
  # GET /analyses/:mda_id/operations/new
  def new
    @mda = Analysis.find(params[:mda_id])
    @ope = @mda.operations.build
  end
  
  # GET /operations/1/edit
  def edit
  end
  
  # POST /analyses/:mda_id/operations
  def create
    if params[:cancel_button]
      redirect_to mda_url(params[:mda_id]), notice: "Operation creation cancelled."
    else 
      @mda = Analysis.find(params[:mda_id])
      @ope = @mda.operations.create(ope_params)
      redirect_to edit_operation_url(@ope)
    end 
  end
  
  # PATCH/PUT /operations/1
  def update
    redirect_to edit_operation_url(@ope) 
  end
  
  # DELETE /operations/1
  def destroy
    authorize @ope
    @ope.destroy
    redirect_to mdas_url, notice: 'Operation was successfully destroyed.'
  end
  
  private
  
    def set_ope
      @ope = Operation.find(params[:id])
    end

    def ope_params
      params.require(:operation).permit(:host, :name, cases: [:varname, :coord_index, values: []])
    end
end
