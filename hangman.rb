def load_game
  if File.exist?("saved_game.yml")
    data = YAML.load_file("saved_game.yml")
    @current_word = data[:current_word]
    @masked_word = data[:masked_word]
    @attempts = data[:attempts]
    @guessed_letters = data[:guessed_letters]
    @current_player = data[:current_player]
    puts "Game loaded successfully!".colorize(:green)
    true
  else
    puts "No saved game found!".colorize(:red)
    false
  end
end


def initialize_game
  @masked_word = '_' * @current_word.length
  @attempts = 6
  @guessed_letters = []
end


def print_hangman(wrong_guesses)
  hangman = [
    "   +---+\n       |\n       |\n       |\n      ===",
    "   +---+\n   O   |\n       |\n       |\n      ===",
    "   +---+\n   O   |\n   |   |\n       |\n      ===",
    "   +---+\n   O   |\n  /|   |\n       |\n      ===",
    "   +---+\n   O   |\n  /|\\  |\n       |\n      ===",
    "   +---+\n   O   |\n  /|\\  |\n  /    |\n      ===",
    "   +---+\n   O   |\n  /|\\  |\n  / \\  |\n      ==="
  ]
  puts hangman[wrong_guesses].colorize(:yellow)
end


def display_menu
  puts "\n~~~ Hangman Menu ~~~".colorize(:magenta)
  puts "1. Start New Game".colorize(:cyan)
  puts "2. Resume Saved Game".colorize(:cyan)
  puts "3. View Scoreboard".colorize(:cyan)
  puts "4. Exit".colorize(:cyan)
  print "Your choice: ".colorize(:yellow)
end
