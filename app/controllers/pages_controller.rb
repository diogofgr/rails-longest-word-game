require 'longest_word'

class PagesController < ApplicationController
  def game
    @grid_size = 6;
    @grid = generate_grid(@grid_size);
  end

  def score
    @user_word = params[:query]
    @start_time = params[:start_time].to_datetime
    @grid = params[:grid]
    # ask for response from coach_answer.rb:
    @result = run_game(@user_word, @grid, @start_time, Time.now)
  end
end
