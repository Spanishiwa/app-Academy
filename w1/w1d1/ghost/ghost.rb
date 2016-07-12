class Game
  attr_accessor :current_player, :fragment, :current_idx, :players

  def initialize(dict, *players)
    @players = players
    @fragment = ''
    @dictionary = File.readlines(dict).map(&:chomp)
    @current_idx = 0
    @current_player = @players[@current_idx]
  end

  def play_round

    until over?
      puts "Current fragment: #{@fragment}"
      take_turn
      next_player
    end
    after_round
    puts "Round over, #{@current_player.name} won!"
  end

  def play_game
    until @players.select { |player| player.alive }.count == 1
      play_round
    end
    puts "Game over #{@players.select { |player| player.alive}.first.name} won"
  end

  def after_round
    previous_player.losses += 1
    display_standings
    previous_player.alive = false if previous_player.losses == 5
    @fragment = ''
  end

  def previous_player
    @players[(current_idx - 1) % @players.length]
  end

  def next_player
    change_player_idx
    change_player_idx until @players[(@current_idx)].alive
    @current_player = @players[(current_idx) % @players.length]
  end

  def change_player_idx
    @current_idx = (@current_idx + 1) % @players.length
  end


  def take_turn
    begin
      input = prompt
      puts input
    rescue
      puts "Please input valid letter"
      retry
    end
    @fragment << input
  end

  def prompt
    puts "#{@current_player.name} give me a character: "
    input = @current_player.give_input(@fragment, @players.count { |player| player.alive })

    raise "Invalid input" unless valid_play?(input)
    input
  end

  def valid_play?(string)
    return false unless ('a'..'z').to_a.include?(string)
    dict_check(string)
  end

  def dict_check(str)
    test_str = @fragment + str
    @dictionary.any? { |word| word[0...test_str.length] == test_str}
  end

  def over?
    @dictionary.none? { |word| word[0...@fragment.length] == @fragment &&
     word.length > @fragment.length }
  end

  def display_standings
    @players.each { |player| puts "#{player.name}: #{player.record}"}
  end

end

class Player
  attr_accessor :losses, :alive
  attr_reader :name

  def initialize(name)
    @name = name
    @losses = 0
    @alive = true
    @dictionary = File.readlines('dictionary.txt').map(&:chomp)
  end

  def record
    "GHOST".chars.take(@losses).join('')
  end

  def give_input(fragment, num_players)
    gets.chomp
  end
end

require 'byebug'
class AI < Player

  def initialize(name)
    @name = name
    super
  end

  def give_input(fragment, num_players)
    #logic based on current fragment
    # debugger

    ('a'..'z').to_a.each { |char| return char if winning_move?(char, fragment, num_players) && valid_play?(char, fragment) }
    ('a'..'z').to_a.each { |char| return char unless losing_move?(char, fragment) && !valid_play?(char, fragment) }
  end

  def losing_move?(letter, fragment)
    test_frag = fragment + letter
    @dictionary.none? { |word| word[0...test_frag.length] == test_frag &&
     word.length > test_frag.length }
  end

  def winning_move?(letter, fragment, num_players)
    test_frag = fragment + letter
    select_dict = @dictionary.select { |word| word[0...test_frag.length] == test_frag }
    select_dict.all? { |word| word.length < test_frag.length + num_players }
  end

  def valid_play?(string, fragment)
    return false unless ('a'..'z').to_a.include?(string)
    dict_check(string, fragment)
  end

  def dict_check(str, fragment)
    test_str = fragment + str
    @dictionary.any? { |word| word[0...test_str.length] == test_str}
  end
end

if __FILE__ == $PROGRAM_NAME
  b = Player.new("Brent")
  m = Player.new("Michael")
  c = AI.new('ai')
  Game.new('dictionary.txt', b, m, c).play_game
end
