class Mission < ApplicationRecord
  belongs_to :agent

  validates :title, presence: true
  validates :status, presence: true

  def status=(value)
    allowed = %w[pending in_progress completed failed assigned]
    if value.present? && !value.in?(allowed)
      raise ArgumentError, "Invalid status: #{value}"
    end
    super(value)
  end
end
