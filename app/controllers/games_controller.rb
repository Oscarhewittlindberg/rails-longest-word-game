require 'open-uri'
require 'json'

class GamesController < ApplicationController
  #  have a view attached
  def new
    @letters = ('A'..'Z').to_a.sample(9)
  end
  # have a view attached
  def score
    @grid = params[:letters]
    @guess = params[:attempt]
    @result = run_game(@guess, @grid)
  end

  def included?(guess, grid)
    guess.chars.all? { |letter| guess.count(letter) <= grid.count(letter) }
  end

  def run_game(guess, grid)
    result = {}
    score_and_message = score_and_message(guess, grid)
    result[:score] = score_and_message.first
    result[:message] = score_and_message.last

    result
  end

  def score_and_message(guess, grid)
    if included?(guess.upcase, grid)
      if english_word?(guess)
        score = guess.length
        [score, 'well done']
      else
        [0, 'not an english word']
      end
    else
      [0, 'not in the grid']
    end
  end

  def english_word?(guess)
    response = open("https://wagon-dictionary.herokuapp.com/#{guess}")
    json = JSON.parse(response.read)
    return json['found']
  end
end
