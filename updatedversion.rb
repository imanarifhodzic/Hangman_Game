def play_game
  puts "\n~~~ Welcome to Hangman ~~~".colorize(:magenta)
  if @current_player.empty?
    print "Enter your name: ".colorize(:yellow)
    @current_player = gets.chomp
  end

  if @current_word.empty?
    @current_word = @words.sample
    initialize_game
  end

  while @attempts > 0
    puts "\nCurrent Word: #{@masked_word}".colorize(:green)
    print_hangman(6 - @attempts)
    print "Guessed letters: #{@guessed_letters.join(', ')}\n".colorize(:cyan)
    print "Enter a letter (or type 'save' to save game): ".colorize(:yellow)
    guess = gets.chomp.downcase

    if guess == "save"
      save_game
      break
    end

    if @guessed_letters.include?(guess)
      puts "You already guessed that letter!".colorize(:red)
    elsif guess.length != 1 || !('a'..'z').include?(guess)
      puts "Invalid input. Please guess a single letter.".colorize(:red)
    else
      @guessed_letters << guess
      if @current_word.include?(guess)
        puts "Good guess!".colorize(:green)
        @current_word.chars.each_with_index do |char, index|
          @masked_word[index] = char if char == guess
        end
      else
        puts "Wrong guess!".colorize(:red)
        @attempts -= 1
      end
    end

    break if @masked_word == @current_word
  end

  if @masked_word == @current_word
    puts "Congratulations, you guessed the word: #{@current_word}".colorize(:bright_green)
    update_scoreboard(@current_player, true)
  else
    puts "You lost! The word was: #{@current_word}".colorize(:red)
    update_scoreboard(@current_player, false)
  end
end

def start_game
  initialize_leaderboard
  loop do
    display_menu
    choice = gets.chomp.to_i
    case choice
    when 1
      @current_word = ''
      play_game
    when 2
      if load_game
        play_game
      end
    when 3
      display_scoreboard
    when 4
      puts "Exiting the game. Goodbye!".colorize(:cyan)
      break
    else
      puts "Invalid choice! Please select 1-4.".colorize(:red)
    end
  end
end

start_game