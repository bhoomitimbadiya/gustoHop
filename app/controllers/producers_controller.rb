class ProducersController < ApplicationController
  skip_before_action :authenticate_user!, only: [ :index ]
  before_action :set_island
  before_action :set_producer, only: [ :show, :edit, :update, :destroy]

  def index
    # NOT WORKING
    # @producers = Producer.all
    # @producers = Producer.where(island_id: params[:island_id])
    # @producers = policy_scope(Producer)

    # WORKING >> I needed revise the policy_scope after integrating the Pundit gem for authorization
    @producers = policy_scope(@island.producers)
  end

  def show
  end

  def new
    @producer = Producer.new
    authorize @producer
  end

  def create
    @producer = @island.producers.create(producer_params)
    # redirect_to island_path(@island)
    @producer.user = current_user
    authorize @producer
    # WORKING >> REDIRECTING TO ISLAND SHOWPAGE
    if @producer.save!
      redirect_to island_producer_path(@island, @producer), notice: "Producer was successfully created!"
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @producer.update!(producer_params)
      redirect_to island_producer_path, notice: "Edits saved!"
    else
      render :edit
    end
  end

  def destroy
    @producer.destroy
    redirect_to island_producers_path, notice: "the producer has been removed."
  end

  private

  def set_island
    @island = Island.find(params[:island_id])
  end

  def set_producer
    @producer = @island.producers.find(params[:id])
    authorize @producer
  end

  # delete? >> keeping in efforts to debug index view
  def island_params
    params.require(:island).permit(:island_name, :island_country)
  end

  def producer_params
    params.require(:producer).permit(:producer_name, :email, :address1, :address2, :postal_code, :city, :country, :photo)
  end
end
