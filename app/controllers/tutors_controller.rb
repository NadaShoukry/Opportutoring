class TutorsController < ApplicationController
  def show
    # disallow a tutor to view a non-existing tutor's profile
    begin
      @tutor = Tutor.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      redirect_to root_url
    end
  end

  def index
    @tutors = Tutor.all
  end

  def mystudents
    @tutor = Tutor.find(params[:id])
  end

  #This action will render app/views/tutors/new.html.erb
  def new
    #initialize but not save an empty tutor; so that the form we renders knows which fields to use and where to submit
    @tutor = Tutor.new
  end

  def create
    @tutor = Tutor.new(tutor_params)

    if @tutor.save
      session[:tutor_id] = @tutor.id
      session[:student_id] = nil
      redirect_to root_url, notice: "Logged in!"
    else
      # can setup an error message here
      render :new
    end
  end

  #This action will render app/views/tutors/edit.html.erb
  def edit
    # disallow a tutor to edit a non-existing tutor's profile
    begin
      @tutor = Tutor.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      redirect_to root_url
      return
    end

    # disallow a tutor to edit another tutor's profile
    if session[:tutor_id] != @tutor.id
      redirect_to root_url
    end
  end

  def update
    @tutor = Tutor.find(params[:id])

    if @tutor.update(tutor_params)
      redirect_to action: "show", id: @tutor.id
    else
      # can setup an error message here
      render :edit
    end
  end

  # helper
  private

  # require a tutor object to be in "params" object (= object that contains all parameters being passed into the request)
  # also requires (only) specified paramaters to exits in "params" object
  # permit some attributes to be used in the returned hash (whitelist)
  # if checks are passed, returns a hash that is used here to create or update a tutor object
  def tutor_params
    params.require(:tutor).permit(:name, :password, :password_confirmation, :country, :email, :image)
  end
end
