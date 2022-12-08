require "pry"

class RucksackDifferenceFinder
  PRIORITY_VALUE = {
    'a' => 1, 'b' => 2, 'c' => 3, 'd' => 4, 'e' => 5, 'f' => 6, 'g' => 7, 'h' => 8, 'i' => 9, 'j' => 10,
    'k' => 11, 'l' => 12, 'm' => 13, 'n' => 14, 'o' => 15, 'p' => 16, 'q' => 17, 'r' => 18, 's' => 19, 't' => 20,
    'u' => 21, 'v' => 22, 'w' => 23, 'x' => 24, 'y' => 25, 'z' => 26,
    'A' => 27, 'B' => 28, 'C' => 29, 'D' => 30, 'E' => 31, 'F' => 32, 'G' => 33, 'H' => 34, 'I' => 35, 'J' => 36,
    'K' => 37, 'L' => 38, 'M' => 39, 'N' => 40, 'O' => 41, 'P' => 42, 'Q' => 43, 'R' => 44, 'S' => 45, 'T' => 46,
    'U' => 47, 'V' => 48, 'W' => 49, 'X' => 50, 'Y' => 51, 'Z' => 52
  }.freeze

  def initialize(input_file)
    @input_file = input_file
  end

  def puzzle_1_answer
    get_rucksacks_priority_value
  end

  def puzzle_2_answer
    get_groups_priority_value
  end

  def get_rucksacks_priority_value
    value = 0

    rucksacks.each do |rucksack|
      value += get_rucksack_priority_value(rucksack)
    end

    value
  end

  def get_groups_priority_value
    value = 0
    rucksack_groups.each do |group|
      value += get_group_priority_value(group)
    end

    value
  end

  private def get_rucksack_priority_value(rucksack)
    compartments = split_rucksack_into_compartments(rucksack)
    PRIORITY_VALUE[shared_item_between_compartments(compartments)]
  end

  private def get_group_priority_value(group)
    PRIORITY_VALUE[shared_item_between_group(group)]
  end

  private def split_rucksack_into_compartments(rucksack)
    [rucksack[0, rucksack.length / 2], rucksack[rucksack.length / 2, rucksack.length / 2]]
  end

  private def shared_item_between_compartments(compartments)
    (compartments[0].chars & compartments[1].chars).first
  end

  private def shared_item_between_group(group)
    elf_1, elf_2, elf_3 = group[0], group[1], group[2]
    (elf_1.chars & elf_2.chars & elf_3.chars).first
  end

  private def rucksacks
    @rucksacks ||= file_contents.split("\n")
  end

  private def rucksack_groups
    @rucksack_groups ||= rucksacks.each_slice(3).to_a
  end

  private def file_contents
    @file_contents ||= File.read("./#{@input_file}")
  end
end
