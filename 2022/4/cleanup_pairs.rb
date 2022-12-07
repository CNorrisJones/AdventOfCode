class CleanupPairs
  def initialize(input_file)
    @input_file = input_file
  end

  def puzzle_1_answer

  end

  def puzzle_2_answer

  end

  private def file_contents
    @file_contents ||= File.read("./#{@input_file}")
  end
end
