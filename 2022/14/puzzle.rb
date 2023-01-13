require "pry"

SAND = "o"
ROCK = "#"
AIR = "."
SAND_SPAWN = "+"

class PuzzleSolver
  def initialize(input_file)
    @input_file = input_file
  end

  def puzzle_1_answer
    get_sand_that_hits_abyss
  end

  def puzzle_2_answer
    get_sand_that_hits_spawn
  end

  private def get_sand_that_hits_abyss
    SandMap.new(file_contents).sand_that_hits_abyss
  end

  private def get_sand_that_hits_spawn
    SandMap.new(file_contents).sand_that_hits_spawn
  end

  private def file_contents
    @file_contents ||= File.read("./#{@input_file}")
  end
end

class SandMap
  def initialize(input)
    @input = input

    @min_x, @max_x = set_x_values
    @min_y, @max_y = set_y_values

    @map = initialize_sand_map
  end

  def sand_that_hits_abyss
    sand_counter = 0

    while true
      sand = Sand.new(@map, (@max_y + 1))

      if sand.in_abyss
        return sand_counter
      end

      sand_counter += 1
    end
  end

  def sand_that_hits_spawn
    sand_counter = 0

    while true
      sand = Sand.new(@map, (@max_y + 1))

      sand_counter += 1

      if sand.in_spawn
        return sand_counter
      end
    end
  end

  def visualize_map
    (@min_y..(@max_y + 3)).each do |y_val|
      scan_line = []
      ((@min_x - 3)..(@max_x + 3)).each do |x_val|
        scan_line << @map[[x_val, y_val]]
      end

      puts "#{scan_line.join}"
    end

    puts "\n\n"
    return
  end

  private def initialize_sand_map
    sand_map = Hash.new(AIR)

    set_sand_spawn(sand_map)
    set_map_lines(sand_map)
    set_floor(sand_map)

    sand_map
  end

  private def set_sand_spawn(map)
    map[[500, 0]] = SAND_SPAWN
  end

  private def set_map_lines(map)
    map_instructions.each do |instruction|
      instruction_breakdown = instruction.split(" -> ").map { |coord| coord.split(",").map(&:to_i) }

      current_coord = instruction_breakdown.shift
      end_coord = instruction_breakdown.shift
      draw_line(map, current_coord, end_coord)

      until instruction_breakdown.empty?
        current_coord = end_coord
        end_coord = instruction_breakdown.shift

        draw_line(map, current_coord, end_coord)
      end
    end

    return
  end

  private def set_floor(map)
    (0..(@max_x + 5000)).each { |floor_segment| map[[floor_segment, @max_y + 2]] = ROCK }
  end

  private def draw_line(map, start_coord, end_coord)
    if start_coord.first == end_coord.first
      draw_vertical_line(map, start_coord.first, start_coord.last, end_coord.last)
    else
      draw_horizontal_line(map, start_coord.last, start_coord.first, end_coord.first)
    end

    return
  end

  private def draw_horizontal_line(map, y_val, x_1, x_2)
    (([x_1, x_2].min)..([x_1, x_2].max)).each do |x_val|
      map[[x_val, y_val]] = ROCK
    end
  end

  private def draw_vertical_line(map, x_val, y_1, y_2)
    (([y_1, y_2].min)..([y_1, y_2].max)).each do |y_val|
      map[[x_val, y_val]] = ROCK
    end
  end

  private def set_x_values
    x_values = map_pairs.map { |pair| pair.first.to_i }

    [x_values.min, x_values.max]
  end

  private def set_y_values
    y_max = map_pairs.map {|pair| pair.last.to_i }.max

    [0, y_max]
  end

  private def map_pairs
    @map_pairs ||= map_instructions.join(" -> ").split(" -> ").map { |pair| pair.split(",") }
  end

  private def map_instructions
    @map_instructions ||= @input.split("\n")
  end
end

class Sand
  attr_reader :in_abyss, :in_spawn, :x_coord, :y_coord

  def initialize(map, y_max)
    @map = map
    @x_coord = 500
    @y_coord = 0
    @y_max = y_max

    @in_abyss = false
    @in_spawn = false

    find_rest_point
  end

  private def at_rest?
    ![below_left, below_right, below].include?(AIR)
  end

  private def below_left
    @map[[(@x_coord - 1), (@y_coord + 1)]]
  end

  private def below_right
    @map[[(@x_coord + 1), (@y_coord + 1)]]
  end

  private def below
    @map[[(@x_coord), (@y_coord + 1)]]
  end

  private def find_rest_point
    until at_rest?

      if below == AIR
        @y_coord += 1
      elsif below_left == AIR
        @y_coord += 1
        @x_coord -= 1
      elsif below_right == AIR
        @y_coord += 1
        @x_coord += 1
      end

      if at_abyss?
        @in_abyss = true
      end
    end

    if at_spawn?
      @in_spawn = true
    end

    @map[[@x_coord, @y_coord]] = SAND
  end

  private def at_abyss?
    @y_coord == @y_max
  end

  private def at_spawn?
    @x_coord == 500 && @y_coord == 0
  end
end