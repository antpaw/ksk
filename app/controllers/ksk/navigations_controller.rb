class Ksk::NavigationsController < Bhf::ApplicationController

  def sort
    Navigation.sort_items(params[:navigation])
    Navigation.find(params[:id]).update_attribute(:parent_id, params[:parent_id])
    head :ok
  end

  def create
    navigation = Navigation.new(params_navigation)
    if navigation.save
      render json: {id: navigation.id}
    else
      render status: 400, json: navigation.errors
    end
  end

  private
    def params_navigation
      params.require(:navigation).permit(:title)
    end

end
