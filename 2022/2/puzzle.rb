class RoShamBoDecider
  HAND_FIXED_SHAPE_SCORE = { 'X' => 1, 'Y' => 2, 'Z' => 3 }.freeze
  HAND_FIXED_ROUND_SCORE = {
    'A' => { 'X' => 3, 'Y' => 6, 'Z' => 0 },
    'B' => { 'X' => 0, 'Y' => 3, 'Z' => 6 },
    'C' => { 'X' => 6, 'Y' => 0, 'Z' => 3 }
  }.freeze

  OUTCOME_FIXED_SHAPE_SCORE = {
    'A' => { 'X' => 3, 'Y' => 1, 'Z' => 2 },
    'B' => { 'X' => 1, 'Y' => 2, 'Z' => 3 },
    'C' => { 'X' => 2, 'Y' => 3, 'Z' => 1 }
  }.freeze
  OUTCOME_FIXED_ROUND_SCORE = { 'X' => 0, 'Y' => 3, 'Z' => 6 }.freeze


  def initialize(input_file)
    @input_file = input_file
  end

  def puzzle_1_answer
    score_matches_when_hand_fixed
  end

  def puzzle_2_answer
    score_matches_when_outcome_fixed
  end

  def score_matches_when_hand_fixed
    score = 0
    match_list.each do |match|
      score += hand_fixed_round_scorer(match[0], match[-1])
    end

    score
  end

  def score_matches_when_outcome_fixed
    score = 0
    match_list.each do |match|
      score += outcome_fixed_round_scorer(match[0], match[-1])
    end

    score
  end

  private def hand_fixed_round_scorer(opponent, you)
    HAND_FIXED_SHAPE_SCORE[you] + HAND_FIXED_ROUND_SCORE[opponent][you]
  end

  private def outcome_fixed_round_scorer(opponent, you)
    OUTCOME_FIXED_SHAPE_SCORE[opponent][you] + OUTCOME_FIXED_ROUND_SCORE[you]
  end

  private def match_list
    file_contents.split("\n")
  end

  private def file_contents
    @file_contents ||= File.read("./#{@input_file}")
  end
end
