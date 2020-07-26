require 'pry'
class Game

  def initialize
    @random_word = :random_word
    @turn = 10
    @guessed = ''
    @correct_guesses = ''
  end

  def play
    start_game
    random_word
    binding.pry

    until game_over?
      round_display
      @turn -= 1
      @guessed += guess
      char_matches
      correct_guesses
      break if check_winner?
    end

    if check_winner?
      puts "You win!"
    else
      puts "You lose!"
    end

  end

  def start_game
    greeting = %{
Welcome to Hangman by Christian Robinson!

If you know the rules, skip this part

For the newbs, here's the rules:
    1. I have a word with me, which you'll have to guess in 10 turns
    2. The word to guess is represented by a row of dashes, representing each letter of the word.
    3. If you guess a letter which occurs in the word, I'll write it in all its correct positions.
    4. Now, normally there's a stick figure which is drawn every time you make a wrong guess
       But, I can't draw something like that.
       So, If you make a wrong guess it'll cost you nothing, Woohoo!. Except for the fact that you wasted a turn.
    5. There'll be a list of letters you guessed shown to you everytime you guess
    6. You can't guess a letter which you have guessed earlier
    7. Boring part ends. Now you can play the game.

Are you ready? You have 10 turns to guess the word I have chosen

Special keys: 'save' to save the game at any point.
              'load' to load the game from it's previous save state.
    }
    puts greeting
  end

  def random_word
    @random_word = File.readlines("5desk.txt").sample.chomp
    @random_word_arr = Array.new(@random_word.length, "_ ")
    @correct_guesses = @random_word_arr.join
  end

  def guess
    gets.chomp 
  end
  
  def char_matches
    @random_word.each_char.with_index do |char, index|
        if char == @guessed[@guessed.length - 1]
            @random_word_arr[index] = char
        end
    end
  end

  def round_display    
    round_text = %{
#{@turn.to_s} turns left: #{@correct_guesses}
Letters guessed: #{@guessed}
Enter a character to guess a word
}
    puts round_text
  end

  def correct_guesses
    @correct_guesses = @random_word_arr.join
  end
  
  def check_winner?
    @random_word == @correct_guesses
  end

  def game_over?
    @turn == 0
  end
end