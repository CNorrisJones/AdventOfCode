require "pry"
require "json"

CONTINUE = 0
ORDERED = true
UNORDERED = false

class PuzzleSolver
  def initialize(input)
    @input_file = input
  end

  def puzzle_1_answer
    get_sum_of_valid_input_indices
  end

  def puzzle_2_answer
  end

  private def get_sum_of_valid_input_indices
    PacketResolver.new(file_contents).resolve_packets
  end

  private def file_contents
    @file_contents ||= File.read("./#{@input_file}")
  end
end

class PacketResolver
  def initialize(input)
    @input = input
    @valid_packet_indices = []
  end

  def resolve_packets
    packet_pairs.each_with_index do |packet_pair, i|
      first, second = packet_pair.split("\n")

      if PacketValidator.valid?(first, second)
        @valid_packet_indices << (i + 1)
      end
    end

    @valid_packet_indices.sum
  end

  private def packet_pairs
    @packet_pairs ||= @input.split("\n\n")
  end

end

class PacketValidator
  def self.valid?(first, second)
    first_parsed = JSON.parse(first)
    second_parsed = JSON.parse(second)

    Comparator.new(first_parsed, second_parsed).ordered?
  end
end

class Comparator
  def initialize(first_list, second_list)
    @first_list = first_list
    @second_list = second_list
  end

  def ordered?
    while !@first_list.empty? || !@second_list.empty?
      @first = @first_list.shift
      @second = @second_list.shift

      if first_empty?
        return ORDERED
      end

      if second_empty?
        return UNORDERED
      end

      if both_ints?
        result = compare_int(@first, @second)
        return result unless result == CONTINUE
      end

      if first_int_second_list?
        result = Comparator.new([@first], @second).ordered?
        return result unless result == CONTINUE
      end

      if first_list_second_int?
        result = Comparator.new(@first, [@second]).ordered?
        return result unless result == CONTINUE
      end

      if both_list?
        result = Comparator.new(@first, @second).ordered?
        return result unless result == CONTINUE
      end
    end

    CONTINUE
  end

  private def first_empty?
    @first.nil?
  end

  private def second_empty?
    @second.nil?
  end

  private def both_ints?
    @first.class == Integer && @second.class == Integer
  end

  private def first_int_second_list?
    @first.class == Integer && @second.class == Array
  end

  private def first_list_second_int?
    @first.class == Array && @second.class == Integer
  end

  private def both_list?
    @first.class == Array && @second.class == Array
  end

  private def compare_int(first, second)
    if first == second
      CONTINUE
    elsif first < second
      ORDERED
    elsif first > second
      UNORDERED
    end
  end
end