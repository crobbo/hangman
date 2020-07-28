require 'yaml'

class Game

  attr_reader :save_game

  def initialize
    @random_word = :random_word
    @turn = 10
    @guessed = ''
    @guess = ''
    @correct_guesses = ''
    @save_game = false
    @file_name = create_unique_file_name
  end

  def play
    start_game
    puts "Do you want to load a previous game? Y/N"
    answer = gets.chomp
    if answer == 'y' || answer == 'Y'
      load_screen
      load_game(gets.chomp.to_i)
      puts "Game Loaded"
    else
      random_word
    end    
    until game_over?
      round_display
      @turn -= 1
      guess
      break if @save_game
      char_matches
      correct_guesses
      break if check_winner?
    end
    
    if @save_game
      puts "Game Saved."
    elsif check_winner?
      puts "You win! The word was #{@correct_guesses}"
    else
      puts "You lose! the word was #{@random_word}"
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
    @random_word = File.readlines("5desk.txt").sample.chomp.downcase
    @random_word_arr = Array.new(@random_word.length, "_ ")
    @correct_guesses = @random_word_arr.join
  end

  def guess
    @guess = gets.chomp
    if @guess == 'save' || @guess == 'Save'
      save_game
    else
      @guessed += @guess
    end
  end
  
  def char_matches
    @random_word.each_char.with_index do |char, index|
        if char == @guessed[@guessed.length - 1]
            @random_word_arr[index] = char + ''
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

  def save_game
    save_object = {
      random_word: @random_word,
      turn: @turn,
      guessed: @guessed,
      guess: @guess,
      correct_guesses: @correct_guesses,
      random_word_arr: @random_word_arr,  
    }
    File.open("save_files/#{@file_name}.yaml", "w") { |file| file.write(YAML.dump(save_object)) }
    @save_game = true
  end

  def load_game(choice)
    file_to_load = Dir.chdir("save_files") { Dir.glob("*.yaml").sort[choice] }
    loaded_game = YAML.load(File.read("save_files/#{file_to_load}"), [Symbol])
    @random_word = loaded_game[:random_word]
    @turn = loaded_game[:turn]
    @guessed = loaded_game[:guessed]
    @guess = loaded_game[:guess]
    @correct_guesses = loaded_game[:correct_guesses]
    @random_word_arr = loaded_game[:random_word_arr]
  end

  def load_screen
    system "clear"
    puts "Press the number of the file you want to load"
    Dir.chdir("save_files") { puts Dir.glob("*.yaml").sort }
  end

  def create_unique_file_name
    Dir.mkdir("save_files")
    count = Dir.glob("save_files/*.yaml").length
    date_and_time = Time.new
    "#{count} - Hangman: #{date_and_time.strftime("%d-%m-%Y %I:%M %p")}"
  rescue Errno::EEXIST
    count = Dir.glob("save_files/*.yaml").length
    date_and_time = Time.new
    "#{count} - Hangman: #{date_and_time.strftime("%d-%m-%Y %I:%M %p")}"
  end
end