require "pry"

class PuzzleSolver
  def initialize(input)
    @input_file = input
  end

  def puzzle_1_answer
    find_uniq_chunk_in_stream_of_size_4
  end

  def puzzle_2_answer
    find_uniq_chunk_in_stream_of_size_14
  end

  private def find_uniq_chunk_in_stream_of_size_4
    data_stream = initial_data_stream
    cursor = StreamCursor.new(data_stream.shift(4), 4)

    loop do
      break if cursor.uniq_chunk?
      cursor.next(data_stream.shift)
    end

    cursor.chars_consumed
  end

  private def find_uniq_chunk_in_stream_of_size_14
    data_stream = initial_data_stream
    cursor = StreamCursor.new(data_stream.shift(14), 14)

    loop do
      break if cursor.uniq_chunk?
      cursor.next(data_stream.shift)
    end

    cursor.chars_consumed
  end

  private def initial_data_stream
    file_contents.rstrip.split("")
  end

  private def file_contents
    @file_contents ||= File.read("./#{@input_file}")
  end
end

class StreamCursor
  attr_reader :current_chunk, :chars_consumed
  def initialize(initial_input, cursor_size)
    @current_chunk = initial_input
    @chars_consumed = cursor_size
  end

  def next(char)
    @current_chunk.shift
    @current_chunk.push(char)
    @chars_consumed += 1
  end

  def uniq_chunk?
    @current_chunk & @current_chunk == @current_chunk
  end
end
