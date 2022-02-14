require 'open-uri'

class GamesController < ApplicationController
  def new
    @letters = ('a'..'z').to_a.sample(10)
  end

  def score
    @letters = params[:letters].delete(' ')
    @word = params[:word]

    if include?(@word, @letters)
      if english_word?(@word)
        @answer = "Congratulations! #{@word} is a valid English word!"
      else
        @answer = "Sorry but #{@word} does not seem to be a valid English word..."
      end
    else
      @answer = "Sorry but #{@word} can't be built out of #{@letters}"
    end
  end

  private

  def english_word?(word)
    response = URI.open("https://wagon-dictionary.herokuapp.com/#{word}")
    json = JSON.parse(response.read)
    json['found']
  end

  def include?(word, letters)
    word.chars.all? { |letter| word.count(letter) <= letters.count(letter) }
  end
end
