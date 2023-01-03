require "pry"

class PuzzleSolver
  def initialize(input)
    @input_file = input
  end

  def puzzle_1_answer
    find_shortest_path_from_start_to_finish
  end

  def puzzle_2_answer
  end

  private def find_shortest_path_from_start_to_finish
    start_node = StartNode.new(0, 0, 0)
    end_node = PathNode.new(2, 5, 0, Float::INFINITY)

    PathFinder.new(file_contents, start_node, end_node).find_shortest_path
  end

  private def file_contents
    @file_contents ||= File.read("./#{@input_file}")
  end
end



class PathFinder
  attr_accessor :path_queue, :height_map

  def initialize(input, start_node, end_node)
    @input = input
    @start_node = start_node
    @end_node = end_node

    @height_map = HeightMap.new(@input, @start_node, @end_node)
    @visited_nodes = [@start_node]
    @path_queue = [@start_node]
  end

  def find_shortest_path
    puts "hi"
  end

  private def travel_paths
    @path_queue.each do |node|

    end
  end
end

class HeightMap
  HEIGHTCONVERTOR = {
    "S" => 0, "E" => 0,
    "a" => 1, "b" => 2, "c" => 3, "d" => 4, "e" => 5, "f" => 6, "g" => 7,
    "h" => 8, "i" => 9, "j" => 10, "k" => 11,  "l" => 12, "m" => 13, "n" => 14,
    "o" => 15, "p" => 16, "q" => 17, "r" => 18, "s" => 19, "t" => 20, "u" => 21,
    "v" => 22, "w" => 23, "x" => 24, "y" => 25, "z" => 26
  }

  attr_accessor :map

  def initialize(input, start_node, end_node)
    @input = input
    @start_node = start_node
    @end_node = end_node
    @map = set_height_map
  end

  def set_height_map
    hash_map = {}

    @input.split("\n").each_with_index do |row, row_num|
      row.split("").each_with_index do |col, col_num|
        height = HEIGHTCONVERTOR[col]
        hash_map[[row_num, col_num]] = PathNode.new(row_num, col_num, height, Float::INFINITY)
      end
    end

    hash_map[@start_node.location] = @start_node
    hash_map[@end_node.location] = @end_node

    hash_map
  end

  def neighbours(node)
    [
      @map[[node.x_coord - 1, node.y_coord]],
      @map[[node.x_coord + 1, node.y_coord]],
      @map[[node.x_coord, node.y_coord - 1]],
      @map[[node.x_coord, node.y_coord + 1]]
    ].compact
  end
end

class PathNode
  attr_reader :height, :x_coord, :y_coord
  attr_accessor :path_value

  def initialize(x_coord, y_coord, height, path_value)
    @height = height
    @x_coord = x_coord
    @y_coord = y_coord
    @path_value = path_value
  end

  def location
    [@x_coord, @y_coord]
  end

  def climbable?(node)
    node.height <= (height + 1)
  end
end

class StartNode < PathNode
  def initialize(x_coord, y_coord, height)
    @x_coord = x_coord
    @y_coord = y_coord
    @height = height
    @path_value = 0
  end
end
