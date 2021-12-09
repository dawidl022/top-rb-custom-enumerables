module Enumerable
  def my_each
    for item in self
      yield(item)
    end
    self
  end

  def my_each_with_index
    i = 0
    for item in self
      yield(item, i)
      i += 1
    end
  end

  def my_select
    result = []

    self.my_each do |item|
      if yield(item)
        result << item
      end
    end

    if self.is_a?(Hash)
      result = result.to_h
    end

    result
  end
  alias my_filter my_select

  def my_all?
    self.my_each do |item|
      return false if !yield(item)
    end

    true
  end

  def my_any?
    self.my_each do |item|
      return true if yield(item)
    end

    false
  end

  def my_none?(&block)
    !self.my_any?(&block)
  end

  def my_count
    count = 0

    self.my_each do |item|
      count += 1 if yield(item)
    end

    count
  end

  def my_map(proc = nil)
    result = []

    self.my_each do |item|
      if proc
        result << proc.call(item)
      else
        result << yield(item)
      end
    end

    if self.is_a?(Hash)
      result = result.to_h
    end

    result
  end
  alias my_collect my_map

  def my_inject(accumulator = nil)
    if accumulator.nil?
      rest_of_items = self.class.new
      i = 0

      for item in self
        if i == 0
          first_item = item
        else
          if self.is_a?(Hash)
            rest_of_items[item[0]] = item[1]
          else
            rest_of_items << item
          end
        end
        i += 1
      end

      accumulator = first_item
    else
      rest_of_items = self
    end

    for item in rest_of_items
      accumulator = yield(accumulator, item)
    end
    accumulator
  end
  alias my_reduce my_inject
end

def multiply_els(numbers)
  numbers.my_inject {|product, element| product * element}
end
