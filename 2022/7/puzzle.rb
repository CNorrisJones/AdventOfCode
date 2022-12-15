require "pry"

class PuzzleSolver
  def initialize(input)
    @input_file = input
  end

  def puzzle_1_answer
    get_sum_of_small_directories
  end

  def puzzle_2_answer
    find_smallest_directory_bigger_than_size
  end

  private def get_sum_of_small_directories
    root_node = RootNode.new
    directory_tree = DirectoryTree.new(instructions, root_node)
    directory_tree.find_sum_of_directories_equal_or_less_than_100_000
  end

  private def find_smallest_directory_bigger_than_size
    root_node = RootNode.new
    directory_tree = DirectoryTree.new(instructions, root_node)
    directory_tree.find_smallest_directory_greater_than_8_381_165
  end

  private def instructions
    @instructions ||= file_contents.split("\n")
  end

  private def file_contents
    @file_contents ||= File.read("./#{@input_file}")
  end
end

class Node
  attr_reader :name

  def initialize(input)
    @name = input.split(" ").last
  end
end

class DirNode < Node
  attr_accessor :files

  def initialize(input)
    @files = []
    super
  end

  def size
    @files.map(&:size).inject(0, &:+)
  end
end

class RootNode < DirNode
  def initialize
    @name = "/"
    @files = []
  end
end

class FileNode < Node
  attr_reader :size

  def initialize(input)
    @size ||= input.split(" ").first.to_i
    super
  end
end

class DirectoryTree
  attr_reader :root, :directories
  def initialize(instructions, root_node)
    @root = root_node
    @instructions = instructions
    @tree_path = [root_node]
    @directories = [root_node]
    @instructions.shift # shift the initial `cd /` instruction, as we've already got that in the tree path

    @current_directory = root_node

    build_directory_tree
  end

  def find_sum_of_directories_equal_or_less_than_100_000
    sum = 0
    @directories.each do |directory|
      if directory.size <= 100_000
        sum += directory.size
      end
    end

    sum
  end

  def find_smallest_directory_greater_than_8_381_165
    min_size = 30_000_000 - (70_000_000 - @root.size)

    @directories.select { |directory| directory.size >= min_size }.min_by { |directory| directory.size }.size
  end

  private def parse_instruction(instruction)
    keyword = instruction.split(" ")[1]
    case keyword
    when "cd"
      change_directory(instruction)
    when "ls"
      list_files
    else
      raise ArgumentError, "Non-standard instruction given"
    end
  end

  private def list_files
    while @instructions.first != nil && @instructions.first.start_with?("$") == false
      file = @instructions.shift
      new_node = create_new_node(file)
      @current_directory.files << new_node

      if new_node.class == DirNode
        @directories << new_node
      end
    end
  end

  private def create_new_node(file)
    keyword, name = file.split(" ")
    if keyword == "dir"
      DirNode.new(file)
    else
      FileNode.new(file)
    end

  end

  private def change_directory(instruction)
    directory = instruction.split(" ").last
    if directory == ".."
      @tree_path.pop
      @current_directory = @tree_path.last
    else
      node = @current_directory.files.select { |file| file.name == directory}.first
      @tree_path.push(node)
      @current_directory = node
    end
  end

  private def build_directory_tree
    while @instructions.count > 0
      parse_instruction(@instructions.shift)
    end
  end
end
