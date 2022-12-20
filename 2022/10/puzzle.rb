require "pry"

class PuzzleSolver
  def initialize(input)
    @input_file = input
  end

  def puzzle_1_answer
    get_sum_of_signal_strengths
  end

  def puzzle_2_answer
    display_image
  end

  private def get_sum_of_signal_strengths
    signal_detector = SignalStrengthDetector.new

    instructions.each do |instruction|
      signal_detector.handle_instruction(instruction)
    end

    signal_detector.output_signal_strength
  end

  private def display_image
    signal_detector = SignalStrengthDetector.new

    instructions.each do |instruction|
      signal_detector.handle_instruction(instruction)
    end

    signal_detector.output_display
  end

  private def instructions
    file_contents.split("\n")
  end

  private def file_contents
    @file_contents ||= File.read("./#{@input_file}")
  end
end

class SignalStrengthDetector
  def initialize
    @x = 1
    @cycles = 0

    @signal_sums = []

    @screen = Array.new(6) { Array.new(40, ".") }
  end

  def handle_instruction(instruction)
    if noop?(instruction)
      handle_noop
    elsif addx?(instruction)
      handle_addx(instruction)
    end
  end

  def output_signal_strength
    puts "Signal Sums are: #{@signal_sums}"
    @signal_sums.slice(0, 6).sum
  end

  def output_display
    @screen.each do |line|
      puts "#{line.join}"
    end

    nil
  end

  private def noop?(instruction)
    instruction == "noop"
  end

  private def handle_noop
    draw_pixel
    @cycles += 1
    check_if_signal_sum

    nil
  end

  private def addx?(instruction)
    instruction.split(" ").first == "addx"
  end

  private def handle_addx(instruction)
    adder = instruction.split(" ").last.to_i

    draw_pixel
    @cycles += 1
    check_if_signal_sum
    draw_pixel
    @cycles += 1
    check_if_signal_sum

    @x += adder
    nil
  end

  private def check_if_signal_sum
    if recordable_cycle?
      @signal_sums << @x * @cycles
    end
  end

  private def draw_pixel
    if pixel_position.include?(cycle_position)
      @screen[current_screen_line][cycle_position] = "#"
    end
  end

  private def recordable_cycle?
    (@cycles + 20) % 40 == 0
  end

  private def current_screen_line
    @cycles / 40
  end

  private def cycle_position
    @cycles % 40
  end

  private def pixel_position
    [@x - 1, @x, @x + 1]
  end
end
