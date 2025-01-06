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

