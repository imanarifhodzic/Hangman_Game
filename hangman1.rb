require 'yaml'
require 'colorize'

@words = ['biology', 'ruby', 'football', 'hangman', 'coding']
@current_word = ''
@masked_word = ''
@attempts = 6
@guessed_letters = []
@leaderboard = {}
@current_player = ''


def initialize_leaderboard
  if File.exist?("leaderboard.yml")
    @leaderboard = YAML.load_file("leaderboard.yml") || {}
  else
    @leaderboard = {}
  end
end


def save_scoreboard
  File.open("leaderboard.yml", "w") do |file|
    file.write(YAML.dump(@leaderboard))
  end
end

def display_scoreboard
  if File.exist?("leaderboard.yml")
    data = YAML.load_file("leaderboard.yml")
    if data.nil? || data.empty?
      puts "Scoreboard is empty. Play a game to populate it!".colorize(:yellow)
    else
      puts "\n~~~ Scoreboard ~~~".colorize(:cyan)
      data.each do |player, stats|
        puts "#{player}: Games Played: #{stats[:games_played]}, Games Won: #{stats[:games_won]}".colorize(:green)
      end
    end
  else
    puts "Scoreboard file not found. Play a game to create it!".colorize(:red)
  end
end

def update_scoreboard(player, won)
  @leaderboard[player] ||= { games_played: 0, games_won: 0 }
  @leaderboard[player][:games_played] += 1
  @leaderboard[player][:games_won] += 1 if won
  save_scoreboard
end


def save_game
  File.open("saved_game.yml", "w") do |file|
    file.write(YAML.dump({
      current_word: @current_word,
      masked_word: @masked_word,
      attempts: @attempts,
      guessed_letters: @guessed_letters,
      current_player: @current_player
    }))
  end
  puts "Game saved!".colorize(:green)
end
