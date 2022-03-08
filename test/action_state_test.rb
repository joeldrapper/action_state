require "test_helper"
require "benchmark"

class ActionStateTest < ActiveSupport::TestCase
  test "it has a version number" do
    assert ActionState::VERSION
  end

  test "equality" do
    assert_predicate_matches_scope Example, :equality
    assert_predicate_matches_scope Example, :inequality
  end

  test "inclusion in enumerable" do
    assert_predicate_matches_scope Example, :inclusion
    assert_predicate_matches_scope Example, :exclusion
  end

  test "covered by range" do
    assert_predicate_matches_scope Example, :covered_by_range
    assert_predicate_matches_scope Example, :not_covered_by_range
  end

  test "excluding" do
    assert_predicate_matches_scope Example, :not_first
  end

  test "arguments" do
    assert_predicate_matches_scope Example, :before, 3.days.ago
  end

  test "composition" do
    assert_predicate_matches_scope Example, :last_week
  end

  private

  def assert_predicate_matches_scope(model, name, *args)
    examples = model.send(name, *args).to_set
    counter_examples = (model.all.to_set - examples)

    assert examples.any?, "No examples for #{name} on #{model.name}."
    assert counter_examples.any?, "No counter examples for #{name} on #{model.name}."

    examples.each do |record|
      assert record.send("#{name}?", *args),
        "The predicate #{name} should have been true on #{record.inspect}."
    end

    counter_examples.each do |record|
      refute record.send("#{name}?", *args),
        "The predicate #{name} should have been false on #{record.inspect}."
    end
  end
end
