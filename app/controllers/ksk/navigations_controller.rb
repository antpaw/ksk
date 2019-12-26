class Ksk::NavigationsController < Bhf::ApplicationController

  def sort
    Navigation.sort_items(params_navigation)
    Navigation.find(params[:id]).update_attribute(:parent_id, params[:parent_id])
    head :ok
  end

  def create
    n = Navigation.new(params_navigation)
    if n.save
      render json: {id: n.id}
    else
      render status: 400, json: n.errors
    end
  end
  
  private
    def params_navigation
      a = params.require(:navigation).permit(:title)
      a
    end

end
