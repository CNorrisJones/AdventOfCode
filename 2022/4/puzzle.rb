require "pry"

class CleanupPairs
  def initialize(input_file)
    @input_file = input_file
  end

  def puzzle_1_answer
    find_containing_pairs
  end

  def puzzle_2_answer
    find_overlapping_pairs
  end

  private def find_overlapping_pairs
    overlapping_pairs = 0

    pairs.each do |pair|
      schedule_1, schedule_2 = setup_schedules(pair)
      overlapping_pairs += 1 unless (schedule_1.full_schedule & schedule_2.full_schedule).empty?
    end

    overlapping_pairs
  end

  private def find_containing_pairs
    containing_pairs = 0

    pairs.each do |pair|
      schedule_1, schedule_2 = setup_schedules(pair)
      containing_pairs += 1 if schedule_1.within?(schedule_2) || schedule_1.envelopes?(schedule_2)
    end

    containing_pairs
  end

  private def setup_schedules(pair)
    formatted_pair(pair).map do |areas|
      setup_schedule(areas)
    end
  end

  private def setup_schedule(areas)
    Schedule.new(*areas.split("-").map(&:to_i))
  end

  private def formatted_pair(pair)
    pair.split(",")
  end

  private def pairs
    @pairs ||= file_contents.split("\n")
  end

  private def file_contents
    @file_contents ||= File.read("./#{@input_file}")
  end
end

class Schedule
  attr_reader :first, :last

  def initialize(first, last)
    @first = first
    @last = last
  end

  def full_schedule
    (first..last).to_a
  end

  def within?(schedule)
    raise ArgumentError, "Provided argument must be of class Schedule" unless schedule.class == Schedule
    first >= schedule.first && last <= schedule.last
  end

  def envelopes?(schedule)
    raise ArgumentError, "Provided argument must be of class Schedule" unless schedule.class == Schedule
    first <= schedule.first && last >= schedule.last
  end
end
