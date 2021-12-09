require_relative "../lib/custom_enumerable"

RSpec.describe Enumerable do
  evens = Proc.new { |x| x.even? }
  even_values = Proc.new { |key, value| value.even? }
  times_two = Proc.new { |x| x * 2 }
  time_two_values = Proc.new { |key, value| [key, value * 2] }
  sum_all = Proc.new { |sum, value| sum + value }
  sum_values = Proc.new { |sum, (key, value)| sum + value }

  describe "#my_each" do
    describe "works with arrays" do
      array = [1, 2, 3, 4, 5]
      expected = []
      actual = []

      expected_return = array.each { |num| expected.push(num * 2) }
      actual_return = array.my_each { |num| actual.push(num * 2) }

      it "executes a block for each element" do
        expect(actual).to eq(expected)
      end

      it "returns the original object" do
        expect(actual_return).to eq(expected_return)
      end
    end

    describe "works with hashes" do
      hash = {a: 12, b: 13, z: "ff"}
      expected = []
      actual = []

      expected_return = hash.each { |pair| expected.push(pair) }
      actual_return = hash.my_each { |pair| actual.push(pair) }

      it "executes a block for each element" do
        expect(actual).to eq(expected)
      end

      it "returns the original object" do
        expect(actual_return).to eq(expected_return)
      end

    end
  end

  describe "#my_each_with_index" do
    describe "works with arrays" do
      array = [1, 2, 3, 4, 5]
      expected = []
      actual = []

      expected_return = array.each_with_index do |num, index|
        expected.push([num, index])
      end

      actual_return = array.my_each_with_index do |num, index|
        actual.push([num, index])
      end

      it "executes a block for each element with the item and index" do
        expect(actual).to eq(expected)
      end

      it "returns the original object" do
        expect(actual_return).to eq(expected_return)
      end
    end

    describe "works with hashes" do
      hash = {a: 12, b: 13, z: "ff"}
      expected = []
      actual = []


      expected_return = hash.each_with_index do |num, index|
        expected.push([num, index])
      end

      actual_return = hash.my_each_with_index do |num, index|
        actual.push([num, index])
      end

      it "executes a block for each element with the item and index" do
        expect(actual).to eq(expected)
      end

      it "returns the original object" do
        expect(actual_return).to eq(expected_return)
      end
    end
  end

  describe "#my_select" do
    describe "works with arrays" do
      array = [1, 2, 3, 4, 5, 6]

      it "returns a filtered array" do
        expect(array.my_select(&evens)).to eq(array.select(&evens))
      end

      it "#my_filter is an alias" do
        expect(array.my_filter(&evens)).to eq(array.select(&evens))
      end
    end

    describe "works with hashes" do
      it "returns a filtered hash" do
        hash = {a: 1, b: 2, c: 3, d: 4, e: 5, f: 6}

        expect(hash.my_select(&even_values)).to eq(hash.select(&even_values))
      end
    end
  end

  describe "#my_all?" do
    describe "works with arrays" do
      it "returns true for an empty array" do
        expect([].my_all?(&evens)).to eq([].all?(&evens));
      end

      it "returns true when all elements fulfil the block condition" do
        array = [2, 4, 8, 10]

        expect(array.my_all?(&evens)).to eq(array.all?(&evens))
      end

      it "returns false when at least one element doesn't fulfil condition" do
        array = [2, 4, 6, 8, 9, 10]

        expect(array.my_all?(&evens)).to eq(array.all?(&evens))
      end
    end

    describe "works with hashes" do
      it "returns true for an empty hash" do
        expect({}.my_all?(&even_values)).to eq({}.all?(&even_values));
      end

      it "returns true when all elements fulfil the block condition" do
        hash = {a: 2, b: 4, c: 8, d: 10}

        expect(hash.my_all?(&even_values)).to eq(hash.all?(&even_values))
      end

      it "returns false when at least one element doesn't fulfil condition" do
        hash = {a: 2, b: 4, c: 6, d: 8, e: 9, f: 10}

        expect(hash.my_all?(&even_values)).to eq(hash.all?(&even_values))
      end
    end
  end

  describe "#my_any?" do
    describe "works with arrays" do
      it "returns false for an empty array" do
        expect([].my_any?(&evens)).to eq([].any?(&evens))
      end

      it "returns true when at least 1 element fulfils the condition" do
        array = [1, 3, 7, 9, 10, 11]

        expect(array.my_any?(&evens)).to eq(array.any?(&evens))
      end

      it "returns false when no elements fulfil condition" do
        array = [1, 3, 7, 9, 11]

        expect(array.my_any?(&evens)).to eq(array.any?(&evens))
      end
    end

    describe "works with hashes" do
      it "returns false for an empty hash" do
        expect({}.my_any?(&even_values)).to eq({}.any?(&even_values))
      end

      it "returns true when at least 1 element fulfils the condition" do
        hash = {a: 2, b: 4, c: 6, d: 8, e: 9, f: 10}

        expect(hash.my_any?(&even_values)).to eq(hash.any?(&even_values))
      end

      it "returns false when no elements fulfil condition" do
        hash = {a: 1, b: 3, e: 9}

        expect(hash.my_any?(&even_values)).to eq(hash.any?(&even_values))
      end
    end
  end

  describe "#my_none?" do
    describe "works with arrays" do
      it "returns true for an empty array" do
        expect([].my_none?(&evens)).to eq([].none?(&evens))
      end

      it "returns false when at least 1 element fulfils the condition" do
        array = [1, 3, 7, 9, 10, 11]

        expect(array.my_none?(&evens)).to eq(array.none?(&evens))
      end

      it "returns true when no elements fulfil condition" do
        array = [1, 3, 7, 9, 11]

        expect(array.my_none?(&evens)).to eq(array.none?(&evens))
      end
    end

    describe "works with hashes" do
      it "returns true for an empty hash" do
        expect({}.my_none?(&even_values)).to eq({}.none?(&even_values))
      end

      it "returns false when at least 1 element fulfils the condition" do
        hash = {a: 2, b: 4, c: 6, d: 8, e: 9, f: 10}

        expect(hash.my_none?(&even_values)).to eq(hash.none?(&even_values))
      end

      it "returns true when no elements fulfil condition" do
        hash = {a: 1, b: 3, e: 9}

        expect(hash.my_none?(&even_values)).to eq(hash.none?(&even_values))
      end
    end
  end

  describe "#my_count" do
    describe "works with arrays" do
      it "returns 0 for an empty array" do
        expect([].my_count(&evens)).to eq([].count(&evens))
      end

      it "counts the number of elements fulfilling condition" do
        array = [2, 4, 5, 7, 10]

        expect(array.my_count(&evens)).to eq(array.count(&evens))
      end
    end

    describe "works with hashes" do
      it "returns 0 for an empty hash" do
        expect({}.my_count(&even_values)).to eq({}.count(&even_values))
      end

      it "counts the number of elements fulfilling condition" do
        hash = {a: 2, b: 4, c: 6, d: 8, e: 9, f: 10}

        expect(hash.my_count(&even_values)).to eq(hash.count(&even_values))
      end
    end
  end

  describe "#my_map" do
    describe "works with arrays" do
      it "returns an array with the given mapping" do
        array = [1, 3, 7, 9, 11]

        expect(array.my_map(&times_two)).to eq(array.map(&times_two))
      end
    end

    describe "works with hashes" do
      it "returns a hash with the given mapping" do
        hash = {a: 2, b: 4, c: 6, d: 8, e: 9, f: 10}

        expect(hash.my_map(&time_two_values)).to eq(hash.my_map(&time_two_values))
      end
    end

    it "can also take a proc" do
      array = [1, 3, 7, 9, 11]

      expect(array.my_map(times_two)).to eq(array.map(&times_two))
    end
  end

  describe "#my_inject" do
    describe "works with arrays" do
      it "accumulates a sum with the default accumulator" do
        array = [1, 3, 7, 9, 11]

        expect(array.my_inject(&sum_all)).to eq(array.inject(&sum_all))
      end

      it "accumulates a sum with a starting value as the accumulator" do
        starting_value = 50
        array = [1, 3, 7, 9, 11]

        expect(array.my_inject(starting_value, &sum_all)).to eq(
          array.inject(starting_value, &sum_all)
        )
      end
    end

    describe "#works with hashes" do
      it "accumulates a sum with a starting value as the accumulator" do
        starting_value = 0
        hash = {a: 2, b: 4, c: 6, d: 8, e: 9, f: 10}

        expect(hash.my_inject(starting_value, &sum_values)).to eq(
          hash.inject(starting_value, &sum_values)
        )
      end
    end

    it "#my_reduce is an alias" do
      array = [1, 3, 7, 9, 11]

      expect(array.my_reduce(&sum_all)).to eq(array.reduce(&sum_all))
    end
  end
end

RSpec.describe "#multiply_els" do
  it "multiplies all elements in array together" do
    expect(multiply_els([2,4,5])).to eq(40)
  end
end
