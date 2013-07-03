class Ksk::NavigationsController < Bhf::ApplicationController

  def sort
    Navigation.sort_items(params[:navigation])
    Navigation.find(params[:id]).update_attribute(:parent_id, params[:parent_id])
    head :ok
  end

  def create
    n = Navigation.new(params[:navigation])
    n.save
    render :text => n.id
  end

end

