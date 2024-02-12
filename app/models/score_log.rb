class ScoreLog < ApplicationRecord
  belongs_to :contestant

  validates :previous_score, :new_score, :score_difference, presence: true
  validates :new_score, :previous_score, numericality: { greater_than_or_equal_to: 0 }
  validate :score_difference_consistent, if: -> {
    previous_score.present? && new_score.present? && score_difference.present?
  }

  private

  def score_difference_consistent
    return if previous_score + score_difference == new_score

    errors.add(:score_difference, 'must be the difference between new_score and previous_score')
  end
end
