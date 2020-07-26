# PSUEDOCODE 
#
#  Game selects a random word from dictionary
#  // Method which selects random word & splits it into an array \\
#
#  Player inputs letter and if the letter matches the randomly chosen word then that letter is revealed.
#  // Method which checks if inputted letter matches random word\\
#
#  Player keeps guessing until all letters of the random_word are revealed. If not, the game ends and player loses
#  // Method which plays the game and loops until method game end is true

require_relative 'game.rb'

new_game = Game.new
new_game.play
