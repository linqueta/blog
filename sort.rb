require 'benchmark'
require 'benchmark/ips'
require 'faker'

class Person
  attr_accessor :name, :weight

  def initialize(name:, weight:)
    @name = name
    @weight = weight
  end
end

module SortBySorter
  module_function

  def by_weight_asc(people)
    people.sort_by(&:weight)
  end

  def by_weight_desc(people)
    by_weight_asc(people).reverse
  end
end

module SortSorter
  module_function

  def by_weight_asc(people)
    people.sort { |a, b| a.weight <=> b.weight }
  end

  def by_weight_desc(people)
    people.sort { |a, b| b.weight <=> a.weight }
  end
end

def people
  @people ||= (1..100).map { Faker::Name.name }
end

people

Benchmark.ips do |x|
  x.config(time: 30, warmup: 2)
  x.report('sort') { @people.sort}
  x.report('sort_by') { @people.sort_by { |a| a } }
  x.compare!
end



