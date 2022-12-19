require "pry"

class PuzzleSolver
  def initialize(input)
    @input_file = input
  end

  def puzzle_1_answer
    get_stack_tops_after_moving_cargo
  end

  def puzzle_2_answer
    get_stack_tops_after_moving_cargo_order_remains
  end

  private def get_stack_tops_after_moving_cargo
    cargo_stack = Stacks.new(9, ["LNWTD", "CPH", "WPHNDGMJ", "CWSNTQL", "PHCN", "THNDMWQB", "MBRJGSL", "ZNWGVBRT", "WGDNPL"])

    parsed_instructions.each do |instruction|
      cargo_stack.move_stacks(*instruction)
    end

    cargo_stack.top_of_stacks
  end

  private def get_stack_tops_after_moving_cargo_order_remains
    cargo_stack = Stacks.new(9, ["LNWTD", "CPH", "WPHNDGMJ", "CWSNTQL", "PHCN", "THNDMWQB", "MBRJGSL", "ZNWGVBRT", "WGDNPL"])

    parsed_instructions.each do |instruction|
      cargo_stack.move_stacks_order_remains(*instruction)
    end

    cargo_stack.top_of_stacks
  end

  private def parsed_instructions
    file_contents.split("\n\n").last.split("\n").map do |instruction|
      instruction.scan(/\d+/).map(&:to_i)
    end
  end

  private def file_contents
    @file_contents ||= File.read("./#{@input_file}")
  end
end

class Stacks
  attr_accessor :stacks

  def initialize(num_stacks, stack_contents = [])
    raise ArgumentError, "Length of stack_contents must equal num_stacks" unless num_stacks == stack_contents.length

    @stacks = Array.new(num_stacks){ Stack.new() }
    @stack_crates = stack_contents

    initialize_stacks
  end

  def move_stacks(number_crates, from, to)
    number_crates.times { |_| @stacks[to-1].push(@stacks[from-1].pop) }

    stacks
  end

  def move_stacks_order_remains(number_crates, from, to)
    @stacks[to-1].concat(@stacks[from-1].pop(number_crates))
  end

  def top_of_stacks
    stacks.map do |stack|
      stack.top.nil? ? " " : "#{stack.top}"
    end.join
  end

  private def initialize_stacks
    @stack_crates.each_with_index do |crates, crates_index|
      crates.chars.each { |crate| stacks[crates_index].push(crate) }
    end
  end
end

class Stack
  # Read crates from top to bottom.
  # Ex: If init parameter crates = "CMZ", setup @crates = ["C", "M", "Z"], with "C" at bottom of stack
  def initialize(crates = "")
    @crates = crates.split("")
  end

  def push(crate)
    @crates.push(crate)
  end

  def pop(crates = 1)
    @crates.pop(crates)
  end

  def concat(crates)
    @crates.concat(crates)
  end

  def top
    @crates.last
  end

  def size
    @crates.length
  end
end

