require 'io/console'
require 'yaml'
require 'colorize'

def reload_scoreboard
  if File.exist?('scoreboard_save.yml')
    $scoreboard = YAML.load_file('scoreboard_save.yml')
    $scoreboard = {} unless $scoreboard.is_a?(Hash)
  else
    $scoreboard = {}
  end
end

def save_scoreboard
  File.open('scoreboard_save.yml', 'w') { |file| file.write($scoreboard.to_yaml) }
end

reload_scoreboard

WORDS = ['elektrifikacija', 'matematika', 'sportista', 'fantazija', 'astronaut']
$chosen_word = ''
$masked_word = ''
$remaining_attempts = 6
$guessed_letters = []
$current_player = ''

def draw_hangman(mistakes)
  hangman = "   +---+\n       |\n       |\n       |\n      ===\n"

  case mistakes
  when 1
    hangman = "   +---+\n   O   |\n       |\n       |\n      ===\n".yellow
  when 2
    hangman = "   +---+\n   O   |\n   |   |\n       |\n      ===\n".cyan
  when 3
    hangman = "   +---+\n   O   |\n  /|   |\n       |\n      ===\n".cyan
  when 4
    hangman = "   +---+\n   O   |\n  /|\  |\n       |\n      ===\n".cyan
  when 5
    hangman = "   +---+\n   O   |\n  /|\  |\n  /    |\n      ===\n".cyan
  when 6
    hangman = "   +---+\n   O   |\n  /|\  |\n  / \  |\n      ===\n".cyan
  end

  puts hangman
end

def persist_game(filename)
  game_state = {
    word: $chosen_word,
    masked_word: $masked_word,
    attempts: $remaining_attempts,
    guessed_letters: $guessed_letters,
    current_player: $current_player
  }
  File.write(filename, YAML.dump(game_state))
  puts 'Game saved!'
end

def reload_game(filename)
  game_state = YAML.load_file(filename)
  $chosen_word = game_state[:word]
  $masked_word = game_state[:masked_word]
  $remaining_attempts = game_state[:attempts]
  $guessed_letters = game_state[:guessed_letters]
  $current_player = game_state[:current_player]
  puts 'Game loaded!'
end

def persist_scoreboard(filename)
  File.write(filename, YAML.dump(scoreboard: $scoreboard))
  puts 'Scoreboard saved!'
end



def reload_scoreboard(filename)
  data = YAML.load_file(filename)
  $scoreboard = data[:scoreboard]
  puts 'Scoreboard loaded!'
end

def modify_scoreboard(player, victory)
  $scoreboard[player] ||= { games_played: 0, games_won: 0 }
  $scoreboard[player][:games_played] += 1
  $scoreboard[player][:games_won] += 1 if victory
end

def show_scoreboard
  puts "\n~~~ Scoreboard ~~~".yellow
  $scoreboard.each do |player, stats|
    puts "#{player}: Games Played: #{stats[:games_played]}, Games Won: #{stats[:games_won]}"
  end
end

def show_player_score
  stats = $scoreboard[$current_player]
  puts "\n~~~ Your Score ~~~".yellow
  puts "#{$current_player}: Games Played: #{stats[:games_played]} | Games Won: #{stats[:games_won]}"
end

def main_menu
  puts "\n~~~ Hangman Menu ~~~".magenta
  puts "1. Start New Game".cyan
  puts "2. Resume Saved Game".cyan
  puts "3. Show Scoreboard".cyan
  puts "4. Exit".cyan
end

def reset_game_state(word)
  $chosen_word = word
  $masked_word = '_' * word.length
  $remaining_attempts = 6
  $guessed_letters = []
end

def execute_game
  puts "\n~~~ Welcome to Hangman ~~~".magenta

  if $current_player.empty?
    print "Enter your name: ".yellow
    $current_player = gets.chomp
  end

  draw_hangman(6 - $remaining_attempts)
  puts "Guess the word: #{$masked_word}"

  until $remaining_attempts.zero?
    print "\nEnter a letter: ".yellow
    guess = gets.chomp

    if guess == 'save'
      persist_game('hangman_save.yml')
      exit
    end

    if $guessed_letters.include?(guess)
      puts "You already guessed '#{guess}'. Try again.".red
      next
    end

    unless guess.match?(/^[a-zA-Z]$/)
      puts "Invalid input. Please enter a single letter.".red
      next
    end

    $guessed_letters << guess

    if $chosen_word.include?(guess)
      $chosen_word.chars.each_with_index do |char, index|
        $masked_word[index] = char if char == guess
      end
      puts "Good guess! #{$masked_word}"
    else
      $remaining_attempts -= 1
      puts "Wrong guess! Attempts left: #{$remaining_attempts}".red
      draw_hangman(6 - $remaining_attempts)
    end

    break if $masked_word == $chosen_word
  end

  if $masked_word == $chosen_word
    puts "Congratulations! You guessed the word: #{$chosen_word}".green
    modify_scoreboard($current_player, true)
    show_player_score
  else
    puts "Game over! The word was: #{$chosen_word}".red
    modify_scoreboard($current_player, false)
  end
end

def start_game
  main_menu
  print "Input: ".yellow
  choice = gets.chomp.to_i

  case choice
  when 1
    print "1. Singleplayer\n2. Multiplayer\nInput: ".cyan
    mode = gets.chomp.to_i

    if mode == 2
      print "Enter a word for Player 2 (hidden): ".yellow
      word = STDIN.noecho(&:gets).chomp
      reset_game_state(word)
    else
      reset_game_state(WORDS.sample)
    end

    execute_game
  when 2
    reload_game('hangman_save.yml')
    execute_game
  when 3
    show_scoreboard
    start_game
  when 4
    puts "Exiting the game. Goodbye!".cyan
    persist_scoreboard('scoreboard_save.yml')
    exit
  else
    puts "Invalid choice! Please select 1-4.".red
    start_game
  end
end

reload_scoreboard('scoreboard_save.yml')
start_game
