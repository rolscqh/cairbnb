class RoomsController < ApplicationController
  before_action :set_room, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!, except: [:show]

  def index
      @rooms = Room.all
      if params[:query].present?
      @rooms = Room.search(params[:query])
      else
        @rooms = []
      end
  end

  def autocomplete
    listing_name = Room.search(params[:query], {
      fields: ["listing_name^5"],
      limit: 10,
      load: false,
      misspellings: {below: 5}
    }).map {|room| {title: room.listing_name, value: room.id}}

    address = Room.search(params[:query], {
      fields: ["address"],
      limit: 10,
      load: false,
      misspellings: {below: 5}
    }).map {|room| {title: room.address, value: room.id}}

    render json: listing_name + address
  end

  def show
    @photos = @room.photos
  end

  def new
    @room = current_user.rooms.build
  end

  def create
    @room = current_user.rooms.build(room_params)
    if @room.save
      redirect_to rooms_path, notice: "Saved..."
    else
      render :new
    end
  end

  def edit
    if current_user.id == @room.user.id
      @photos = @room.photos
    else
      redirect_to root_path, notice: "You don't have permission."
    end
  end

  def update
    if @room.update(room_params)

      if params[:images] 
        params[:images].each do |image|
          @room.photos.create(image: image)
        end
      end

      redirect_to edit_room_path(@room), notice: "Updated..."
    else
      render :edit
    end
  end

  def destroy
    @room = Room.find(params[:id])
    @room.destroy
    redirect_to root_path
  end

  private 
    def set_room
      @room = Room.find(params[:id]) 
    end

    def room_params
      params.require(:room).permit(:home_type, :room_type, :accommodate, :bed_room, :bath_room, :listing_name, :summary, :address, :is_tv, :is_kitchen, :is_air, :is_heating, :is_internet, :price, :active)
    end
end
