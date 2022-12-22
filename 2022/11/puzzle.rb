require "pry"

class PuzzleSolver
  def initialize(input)
    @input_file = input
  end

  def puzzle_1_answer
    find_monkey_business_after_twenty_rounds
  end

  def puzzle_2_answer
  end

  private def find_monkey_business_after_twenty_rounds
    MonkeyTroop.new(file_contents, 20).get_monkey_business
  end

  private def file_contents
    @file_contents ||= File.read("./#{@input_file}")
  end
end

class MonkeyTroop
  def initialize(input, number_of_rounds)
    @input = input
    @number_of_rounds = number_of_rounds
  end

  def get_monkey_business
    simulate_rounds
    monkeys.map { |monkey| monkey.inspection_count }.max(2).inject(:*)
  end

  private def simulate_rounds
    @number_of_rounds.times do
      simulate_round
    end
  end

  private def simulate_round
    monkeys.each do |monkey|
      monkey.handle_items
    end

    monkeys_items
  end

  private def monkeys_items
    puts "\n"
    monkeys.each_with_index do |monkey, i|
      puts "Monkey #{i}: #{monkey.items}. Inspection Count: #{monkey.inspection_count}"
    end
    puts "\n"
  end

  private def monkeys
    @monkeys ||= initialize_monkeys
  end

  private def initialize_monkeys
    monkeys = []
    @input.split("\n\n").each do |monkey_input|
      split_input = monkey_input.split("\n")
      starting_items = split_input[1].scan(/\d+/).map(&:to_i)
      operation_symbol = split_input[2].split("  Operation: new = ").last.split(" ")[1]
      operation_val = split_input[2].split(" ").last.split(" ").last
      test_val = split_input[3].split(" ").last.to_i
      true_monkey = split_input[4].split(" ").last.to_i
      false_monkey = split_input[5].split(" ").last.to_i

      monkeys << Monkey.new(
        starting_items: starting_items,
        operation_symbol: operation_symbol,
        operation_val: operation_val,
        test_val: test_val,
        true_monkey: true_monkey,
        false_monkey: false_monkey,
        monkey_troop: monkeys
      )
    end

    monkeys
  end
end

class Monkey
  WORRY_DIVISOR = 3

  attr_reader :items, :inspection_count

  def initialize(starting_items:, operation_val:, operation_symbol:, test_val:, true_monkey:, false_monkey:, monkey_troop:)
    @items = starting_items
    @operation_val = operation_val
    @operation_symbol = operation_symbol
    @test_val = test_val
    @true_monkey = true_monkey
    @false_monkey = false_monkey
    @monkey_troop = monkey_troop
    @inspection_count = 0
  end

  def handle_items
    until @items.empty?
      item = @items.shift
      item = inspect_item(item)
      item = item / WORRY_DIVISOR
      puts "Monkey gets bored with item. Worry level is divided by #{WORRY_DIVISOR} to #{item}"
      throw(item)
    end
  end

  def catch(item)
    @items << item
  end

  private def inspect_item(item)
    puts "Monkey inspects an item with worry level of #{item}"
    value = @operation_val == "old" ? item : @operation_val.to_i

    item = item.send(@operation_symbol, value)
    puts "Worry level is #{@operation_symbol} by #{@operation_val} to #{item}"

    @inspection_count += 1
    item
  end

  private def throw(item)
    if pass_test?(item)
      puts "Current worry level is divisible by #{@test_val}."
      puts "Item with worry level #{item} is thrown to monkey #{@true_monkey}"
      @monkey_troop[@true_monkey].catch(item)
    else
      puts "Current worry level is not divisible by #{@test_val}"
      puts "Item with worry level #{item} is thrown to monkey #{@false_monkey}"
      @monkey_troop[@false_monkey].catch(item)
    end
  end

  private def pass_test?(item)
    item % @test_val == 0
  end
end
