class Ksk::NavigationsController < Bhf::ApplicationController

  def sort
    Navigation.sort_items(params_navigation)
    Navigation.find(params[:id]).update_attribute(:parent_id, params[:parent_id])
    head :ok
  end

  def create
    n = Navigation.new(params_navigation)
    n.save
    render :text => n.id
  end
  
  private
    def params_navigation
      ActionController::Parameters.new(params[:navigation]).permit!
    end

end

