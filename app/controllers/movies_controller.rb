class MoviesController < ApplicationController

  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    redirect = false
    @all_ratings = Movie.select(:rating).map(&:rating).uniq

    if(params[:ratings])
      @ratings = params[:ratings]
    elsif session[:ratings]
      @ratings = session[:ratings]
      retirect = true
    else
      @ratings = Hash[@all_ratings.collect { |item| [item, 1] }]
      redirect = true
    end

     if(params[:sort])
      @sort = params[:sort]
    elsif session[:sort]
      @sort = session[:sort]
      retirect = true
    end
    if redirect
      redirect_to movies_path(:ratings=>@ratings, :sort=>@sort)
    end
    if @ratings
      @movies = Movie.order(@sort).where(rating: @ratings.keys).all
    else
      @movies = Movie.order(params[:sort]).all
    end
 
    if(params[:ratings])
      session[:ratings] = params[:ratings]
    end
    if(params[:sort])
      session[:sort] = params[:sort]
    end
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(movie_params)

    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

end
