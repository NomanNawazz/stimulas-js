class MoviesChannel < ApplicationCable::Channel
  def subscribed
    movie = Movie.find(params[:id])
    stream_for movie
    # stream_from "some_channel"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
