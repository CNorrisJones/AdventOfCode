class PuzzleSolver
  def initialize(input_file)
    @input_file = input_file
  end

  def puzzle_1_answer
    find_most_food
  end

  def puzzle_2_answer
    find_top_three_sum
  end

  def find_most_food
    sum_calories.max()
  end

  def find_top_three_sum
    sum_calories.max(3).inject(0, :+)
  end

  private def sum_calories
    calorie_array.map do |elf_cals|
      elf_cals.inject(0, :+)
    end
  end

  private def calorie_array
    @calorie_array ||= file_contents.split("\n\n").map do |elf_cals|
      elf_cals.split("\n").map(&:to_i)
    end
  end

  private def file_contents
    @file_contents ||= File.read("./#{@input_file}")
  end
end
