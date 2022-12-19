require "pry"

class PuzzleSolver
  def initialize(input)
    @input_file = input
  end

  def puzzle_1_answer
    determine_locations_rope_tail_has_been(1)
  end

  def puzzle_2_answer
    determine_locations_rope_tail_has_been(9)
  end

  private def determine_locations_rope_tail_has_been(rope_length)
    rope = Rope.new(rope_length)

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

  def initialize(rope_length)
    @head = Knot.new(0, 0)

    @tail = []

    set_tail(rope_length)

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
      determine_knot_location
    end
  end

  private def set_tail(rope_length)
    knot_in_front = @head

    rope_length.times do
      current_knot = Knot.new(0, 0, in_front: knot_in_front)
      knot_in_front.behind = current_knot
      knot_in_front = current_knot
      @tail << current_knot
    end
  end

  private def step_head(direction)
    case direction
    when "U"
      @head.y_coord += 1
    when "D"
      @head.y_coord -= 1
    when "L"
      @head.x_coord -= 1
    when "R"
      @head.x_coord += 1
    else
      raise ArgumentError, "Unexpected direction type given"
    end
  end

  private def determine_tail_location
    if distance_from_knot_to_knot_in_front(@tail[0]) >= 2
      move_knot(@tail[0])
      mark_tail_location
    end
  end

  private def determine_knot_location
    @tail.each do |knot|
      if distance_from_knot_to_knot_in_front(knot) >= 2
        move_knot(knot)
        mark_tail_location
      end
    end
  end

  private def distance_from_knot_to_knot_in_front(knot)
    Math.sqrt((knot.x_coord - knot.in_front.x_coord) ** 2 + (knot.y_coord - knot.in_front.y_coord) ** 2)
  end

  private def move_knot(knot)
    if distance_from_knot_to_knot_in_front(knot) == 2
      knot.x_coord = (knot.x_coord + knot.in_front.x_coord) / 2
      knot.y_coord = (knot.y_coord + knot.in_front.y_coord) / 2
    elsif knot.in_front.x_coord > knot.x_coord && knot.in_front.y_coord > knot.y_coord
      knot.x_coord += 1
      knot.y_coord += 1
    elsif knot.in_front.x_coord > knot.x_coord && knot.in_front.y_coord < knot.y_coord
      knot.x_coord += 1
      knot.y_coord -= 1
    elsif knot.in_front.x_coord < knot.x_coord && knot.in_front.y_coord > knot.y_coord
      knot.x_coord -= 1
      knot.y_coord += 1
    elsif knot.in_front.x_coord < knot.x_coord && knot.in_front.y_coord < knot.y_coord
      knot.x_coord -= 1
      knot.y_coord -= 1
    end
  end

  private def move_left_or_right(knot)
    if knot.in_front.x_coord < knot.x_coord
      -1
    else
      1
    end
  end

  private def move_up_or_down(knot)
    if knot.in_front.y_coord < knot.y_coord
      -1
    else
      1
    end
  end

  private def mark_tail_location
    @tail_locations[@tail.last.current_location] = 1
  end
end

class Knot
  attr_accessor :x_coord, :y_coord, :in_front, :behind

  def initialize(x_coord, y_coord, in_front: nil, behind: nil)
    @x_coord = x_coord
    @y_coord = y_coord
    @in_front = in_front
    @behind = behind
  end

  def current_location
    [@x_coord, @y_coord]
  end
end
