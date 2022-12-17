require "pry"

class PuzzleSolver
  def initialize(input)
    @input_file = input
  end

  def puzzle_1_answer
    determine_locations_rope_tail_has_been
  end

  def puzzle_2_answer
  end

  private def determine_locations_rope_tail_has_been
    rope = Rope.new

    instructions.each do |instruction|
      rope.move_head(instruction)
    end

    rope.tail_locations
  end

  private def instructions
    @instructions ||= file_contents.split("\n")
  end

  private def file_contents
    @file_contents ||= File.read("./#{@input_file}")
  end
end

class Rope
  attr_accessor :head, :tail, :tail_locations

  def initialize
    @head = [0, 0]
    @tail = [0, 0]

    @tail_locations = Hash.new(0)
    mark_tail_location
  end

  def tail_locations
    @tail_locations.count
  end

  def move_head(instruction)
    direction = instruction.split(" ").first
    distance = instruction.split(" ").last.to_i

    distance.times do
      step_head(direction)
      determine_tail_location(direction)
    end
  end

  private def step_head(direction)
    x_coord = @head.first
    y_coord = @head.last

    case direction
    when "U"
      y_coord += 1
      @head = [x_coord, y_coord]
    when "D"
      y_coord -= 1
      @head = [x_coord, y_coord]
    when "L"
      x_coord -= 1
      @head = [x_coord, y_coord]
    when "R"
      x_coord += 1
      @head = [x_coord, y_coord]
    else
      raise ArgumentError, "Unexpected direction type given"
    end
  end

  private def determine_tail_location(direction)
    if distance_from_head_to_tail >= 2
      move_tail(direction)
      mark_tail_location
    end
  end

  private def distance_from_head_to_tail
    Math.sqrt((@tail.first - @head.first) ** 2 + (@tail.last - @head.last) ** 2)
  end

  private def move_tail(direction)
    x_coord = @tail.first
    y_coord = @tail.last

    if distance_from_head_to_tail == 2
      case direction
      when "U"
        y_coord += 1
        @tail = [x_coord, y_coord]
      when "D"
        y_coord -= 1
        @tail = [x_coord, y_coord]
      when "L"
        x_coord -= 1
        @tail = [x_coord, y_coord]
      when "R"
        x_coord += 1
        @tail = [x_coord, y_coord]
      else
        raise ArgumentError, "Unexpected direction type given"
      end
    else
      case direction
      when "U"
        x_coord += tail_left_or_right
        y_coord += 1
        @tail = [x_coord, y_coord]
      when "D"
        x_coord += tail_left_or_right
        y_coord -= 1
        @tail = [x_coord, y_coord]
      when "L"
        x_coord -= 1
        y_coord += tail_up_or_down
        @tail = [x_coord, y_coord]
      when "R"
        x_coord += 1
        y_coord += tail_up_or_down
        @tail = [x_coord, y_coord]
      else
        raise ArgumentError, "Unexpected direction type given"
      end
    end
  end

  private def tail_left_or_right
    if @head.first < @tail.first
      -1
    else
      1
    end
  end

  private def tail_up_or_down
    if @head.last < @tail.last
      -1
    else
      1
    end
  end

  private def mark_tail_location
    @tail_locations[@tail] = 1
  end
end
