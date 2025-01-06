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

