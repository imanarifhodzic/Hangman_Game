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