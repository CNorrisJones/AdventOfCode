require "pry"

class PuzzleSolver
  def initialize(input)
    @input_file = input
  end

  def puzzle_1_answer
    find_shortest_path_from_start_to_finish
  end

  def puzzle_2_answer
    find_shortest_starting_point
  end

  private def find_shortest_path_from_start_to_finish
    # start_node = StartNode.new(0, 0, 1)
    # end_node = PathNode.new(5, 2, 26, Float::INFINITY)
    start_node = StartNode.new(0, 20, 1)
    end_node = PathNode.new(58, 20, 26, Float::INFINITY)

    PathFinder.new(file_contents, start_node, end_node).find_shortest_path
  end

  private def find_shortest_starting_point
    # start_node = StartNode.new(0, 0, 1)
    # end_node = PathNode.new(5, 2, 26, 0)
    start_node = StartNode.new(0, 20, 1)
    end_node = PathNode.new(58, 20, 26, 0)

    PathFinder.new(file_contents, start_node, end_node).find_shortest_start_point
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
    @visited_nodes = []
    @path_queue = [@start_node]
  end

  def find_shortest_path
    travel_paths

    @end_node.path_value
  end

  def find_shortest_start_point
    best_start = reverse_travel_paths

    best_start.path_value
  end

  private def travel_paths
    until @path_queue.empty?
      node = @path_queue.shift

      @height_map.neighbours(node).each do |neighbour|
        if node.can_climb_up?(neighbour)
          if neighbour.path_value > node.path_value
            neighbour.path_value = (node.path_value + 1)
          end

          unless @visited_nodes.include?(neighbour) || @path_queue.include?(neighbour)
            @path_queue.append(neighbour)
          end
        end
      end

      @visited_nodes.append(node)
    end
  end

  private def reverse_travel_paths
    @path_queue = [@end_node]

    until @path_queue.empty?
      node = @path_queue.shift

      if node.height == 1
        return node
      end

      @height_map.neighbours(node).each do |neighbour|
        if node.can_climb_down?(neighbour)
          if neighbour.path_value > node.path_value
            neighbour.path_value = (node.path_value + 1)
          end

          unless @visited_nodes.include?(neighbour) || @path_queue.include?(neighbour)
            @path_queue.append(neighbour)
          end
        end
      end

      @visited_nodes.append(node)
    end
  end
end

class HeightMap
  HEIGHTCONVERTOR = {
    "S" => 1, "E" => 26,
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

    @input.split("\n").each_with_index do |col, col_num|
      col.split("").each_with_index do |row, row_num|
        height = HEIGHTCONVERTOR[row]
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

  def can_climb_up?(node)
    node.height <= (height + 1)
  end

  def can_climb_down?(node)
    node.height >= (height - 1)
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
