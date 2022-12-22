require "pry"

class PuzzleSolver
  def initialize(input)
    @input_file = input
  end

  def puzzle_1_answer
  end

  def puzzle_2_answer
  end

  private def file_contents
    @file_contents ||= File.read("./#{@input_file}")
  end
end
