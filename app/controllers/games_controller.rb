require 'open-uri'
require 'json'

class GamesController < ApplicationController
  def new
    @letters = Array.new(10) { ('A'..'Z').to_a.sample }
  end

  def score
    new
    @answer = params[:answer]
    @response =
      if included?(@answer, @letters)
        if english_word?(@answer)
          "Congratulations! #{@answer} is a valid English Word"
        else
          "Sorry but #{@answer} does not seem to be a valid English word ..."
        end
      else
        "Sorry but #{@answer} can't be built out of #{@letters}"
      end
  end

  def english_word?(word)
    response = open("https://wagon-dictionary.herokuapp.com/#{word}")
    json = JSON.parse(response.read)
    json['found']
  end

  def included?(guess, grid)
    guess.chars.all? { |letter| guess.count(letter) <= grid.count(letter) }
  end
end
