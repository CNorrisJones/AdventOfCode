require "pry"

class PuzzleSolver
  def initialize(input)
    @input_file = input
  end

  def puzzle_1_answer
    find_viable_treehouses
  end

  def puzzle_2_answer
  end

  private def find_viable_treehouses
    finder = TreeHouseFinder.new(@file_contents)
    finder.get_number_of_viable_treehouses
  end

  private def file_contents
    @file_contents ||= File.read("./#{@input_file}")
  end
end

class TreeHouseFinder
  def initialize(input)
    @input = input
    @treehouse_hash = Hash.new(0)
  end

  def get_number_of_viable_treehouses
    puts "hi"
  end

  private def map_hash
    @map_hash ||= generate_map_hash
  end

  private def generate_map_hash
    map = {}

    row_number.times do |current_row|
      rows[current_row].chars.each_with_index do |tree_height, current_column|
        map[[current_row, current_column]] = tree_height.to_i
      end
    end

    map
  end

  def row_number
    rows.count
  end

  def rows
    @input.split("\n")
  end
end
