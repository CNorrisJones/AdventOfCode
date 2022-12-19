require "pry"

class PuzzleSolver
  def initialize(input)
    @input_file = input
  end

  def puzzle_1_answer
    get_sum_of_signal_strengths
  end

  def puzzle_2_answer
  end

  private def get_sum_of_signal_strengths
    signal_detector = SignalStrengthDetector.new

    instructions.each do |instruction|
      signal_detector.handle_instruction(instruction)
    end

    signal_detector.output_signal_strength
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
  end

  def handle_instruction(instruction)
    puts "Instruction: #{instruction}. Current X: #{@x}. Current Cycles: #{@cycles}"

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

  private def noop?(instruction)
    instruction == "noop"
  end

  private def handle_noop
    @cycles += 1
    check_if_signal_sum
  end

  private def addx?(instruction)
    instruction.split(" ").first == "addx"
  end

  private def handle_addx(instruction)
    adder = instruction.split(" ").last.to_i

    @cycles += 1
    check_if_signal_sum
    @cycles += 1
    check_if_signal_sum

    @x += adder
  end

  private def check_if_signal_sum
    if recordable_cycle?
      puts "Cycle #{@cycles}. Adding #{@x} * #{@cycles} to Signal Sums."
      @signal_sums << @x * @cycles
    end
  end

  private def recordable_cycle?
    (@cycles + 20) % 40 == 0
  end
end
