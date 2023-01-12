require "pry"

class PuzzleSolver
  def puzzle_1_answer
    get_sand_that_hits_abyss
  end

  def puzzle_2_answer
  end

  private def get_sand_that_hits_abyss

  end

  private def file_contents
    @file_contents ||= File.read("./#{@input_file}")
  end
end

class SandMap
  def initialize(input)
    @input = input
    @min_x, @max_x = set_initial_x_values
    @min_y, @max_y = 0

    binding.pry
  end

  def map
    @map ||= set_sand_map
  end

  private def set_sand_map
    sand_map = Hash.new(".")
  end

  private def set_initial_x_values
    @min_x, @max_x = map_instructions.first.split(",").first.to_i
  end

  private def map_instructions
    @map_instructions ||= @input.split("\n")
  end
end