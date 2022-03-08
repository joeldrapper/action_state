class Example < ApplicationRecord
  include ActionState

  state(:equality) { where(integer: 1) }

  state(:inequality) { where.not(integer: 1) }

  state(:inclusion) { where(integer: [1, 2, 3]) }
  state(:exclusion) { where.not(integer: [1, 2, 3]) }

  state(:covered_by_range) { where(datetime: 3.days.ago..) }
  state(:not_covered_by_range) { where.not(datetime: 3.days.ago..) }

  state(:before) { |whenever| where(datetime: ..whenever) }
  state(:after) { |whenever| where(datetime: whenever..) }

  state(:last_week) { before(1.week.ago).after(2.weeks.ago) }

  state(:not_first) { excluding(Example.order(:id).first) }
end
