require "pry"

class PuzzleSolver
  def initialize(input)
    @input_file = input
  end

  def puzzle_1_answer
    find_viable_treehouses
  end

  def puzzle_2_answer
    find_best_scenic_score
  end

  private def find_viable_treehouses
    finder = TreeHouseFinder.new(file_contents)
    finder.get_number_of_viable_treehouses
  end

  private def find_best_scenic_score
    finder = TreeHouseFinder.new(file_contents)
    finder.find_best_scenic_score
  end

  private def file_contents
    @file_contents ||= File.read("./#{@input_file}")
  end
end

class TreeHouseFinder
  attr_accessor :treehouse_hash

  def initialize(input)
    @input = input
    @treehouse_hash = Hash.new(0)
  end

  def get_number_of_viable_treehouses
    count_valid_trees_in_rows
    reverse_count_valid_trees_in_rows
    count_valid_trees_in_columns
    reverse_count_valid_trees_in_columns

    treehouse_hash.count
  end

  def find_best_scenic_score
    set_viable_scenic_trees

    treehouse_hash.values.max
  end

  private def set_viable_scenic_trees
    viable_scenic_tree_row.each do |row|
      viable_scenic_tree_column.each do |col|
        treehouse_hash[[row, col]] = find_coordinate_scenic_score(row, col)
      end
    end
  end

  private def find_coordinate_scenic_score(row, column)
    north_coordinate_scenic_score(row, column) *
      south_coordinate_scenic_score(row, column) *
      west_coordinate_scenic_score(row, column) *
      east_coordinate_scenic_score(row, column)
  end

  private def north_coordinate_scenic_score(row, column)
    coordinate_tree_height = map_hash[[row, column]]
    score = 0

    (row - 1).downto(0).to_a.each do |northern_tree|
      if map_hash[[northern_tree, column]] < coordinate_tree_height
        score += 1
      else
        score += 1
        return score
      end
    end

    score
  end

  private def south_coordinate_scenic_score(row, column)
    coordinate_tree_height = map_hash[[row, column]]
    score = 0

    ((row + 1)..(row_length - 1)).to_a.each do |southern_tree|
      if map_hash[[southern_tree, column]] < coordinate_tree_height
        score += 1
      else
        score += 1
        break
      end
    end

    score
  end

  private def west_coordinate_scenic_score(row, column)
    coordinate_tree_height = map_hash[[row, column]]
    score = 0

    (column - 1).downto(0).to_a.each do |western_tree|
      if map_hash[[row, western_tree]] < coordinate_tree_height
        score += 1
      else
        score += 1
        break
      end
    end

    score
  end

  private def east_coordinate_scenic_score(row, column)
    coordinate_tree_height = map_hash[[row, column]]
    score = 0

    ((column + 1)..(column_length - 1)).to_a.each do |eastern_tree|
      if map_hash[[row, eastern_tree]] < coordinate_tree_height
        score += 1
      else
        score += 1
        break
      end
    end

    score
  end

  private def viable_scenic_tree_row
    (1..max_scenic_tree_row_coordinate).to_a
  end

  private def viable_scenic_tree_column
    (1..max_scenic_tree_column_coordinate).to_a
  end

  private def max_scenic_tree_row_coordinate
    row_length - 2 # We want to skip the first and last rows
  end

  private def max_scenic_tree_column_coordinate
    column_length - 2 # We want to skip the first and last rows
  end

  private def count_valid_trees_in_rows
    row_length.times do |row|
      current_height_limit = -1
      column_length.times do |col|
        if tree_visible?(row, col, current_height_limit)
          treehouse_hash[[row, col]] = 1
          current_height_limit = map_hash[[row, col]]
        end
      end
    end
  end

  private def reverse_count_valid_trees_in_rows
    row_length.times do |row|
      current_height_limit = -1
      (column_length - 1).downto(0) do |col|
        if tree_visible?(row, col, current_height_limit)
          treehouse_hash[[row, col]] = 1
          current_height_limit = map_hash[[row, col]]
        end
      end
    end

  end

  private def count_valid_trees_in_columns
    column_length.times do |col|
      current_height_limit = -1
      row_length.times do |row|
        if tree_visible?(row, col, current_height_limit)
          treehouse_hash[[row, col]] = 1
          current_height_limit = map_hash[[row, col]]
        end
      end
    end

  end

  private def reverse_count_valid_trees_in_columns
    column_length.times do |col|
      current_height_limit = -1
      (row_length - 1).downto(0) do |row|
        if tree_visible?(row, col, current_height_limit)
          treehouse_hash[[row, col]] = 1
          current_height_limit = map_hash[[row, col]]
        end
      end
    end

  end

  private def tree_visible?(row, column, max_height)
    map_hash[[row, column]] > max_height
  end

  private def map_hash
    @map_hash ||= generate_map_hash
  end

  private def generate_map_hash
    map = {}

    column_length.times do |current_row|
      rows[current_row].chars.each_with_index do |tree_height, current_column|
        map[[current_row, current_column]] = tree_height.to_i
      end
    end

    map
  end

  def column_length
    rows.count
  end

  def row_length
    rows.first.chars.count
  end

  def rows
    @input.split("\n")
  end
end
