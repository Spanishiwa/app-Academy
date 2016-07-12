class Array
  def my_each
    self.length.times do |idx|
      yield(self[idx])
    end
    self
  end

  def my_select
    selected = []
    self.my_each { |el| selected << el if yield(el) }
    selected
  end

  def my_reject
    non_rejected = []
    self.my_each { |el| non_rejected << el unless yield(el) }
    non_rejected
  end

  def my_any?
    self.my_each { |el| return true if yield(el) }
    false
  end

  def my_all?
    self.my_each { |el| return false unless yield(el)}
    true
  end

  def my_flatten
    flattened = []
    self.my_each do |el|
      if el.is_a?(Array)
        flattened += (el.my_flatten)
      else
        flattened << el
      end
    end
    flattened
  end

  def my_zip(*args)
    zipped = []
    (0...self.length).each do |idx|
      subzip = [ self[idx] ]
      args.each { |arg| subzip << arg[idx] }
      zipped << subzip
    end
    zipped
  end

  def my_rotate(num = 1)
    num %= self.length
    self.drop(num) + self.take(num)
  end

  def my_join(sep = '')
    result = ''
    (0...self.length - 1).each { |idx| result << "#{self[idx] + sep}" }
    result + self.last
  end

  def my_reverse
    result = []
    self.each { |el| result = [el] + result }
    result
  end
end

def factors(num)
  factors = []
  (1..num).each {|el| factors << el if num%el == 0}
  factors
end
class Array
  def bubble_sort!(&prc)
    prc ||= Proc.new{|a, b| a <=> b}
    sorted = false
    until sorted
      sorted = true
      (0...self.length-1).each do |idx|
        if prc.call(self[idx], self[idx+1]) == 1
          self[idx], self[idx+1] = self[idx+1], self[idx]
          sorted = false
        end
      end
    end
    self
  end

  def bubble_sort(&prc)
    arr = self.dup
    arr.bubble_sort!(&prc)
  end
end

def substrings(string)
  substrings = []
  (0...string.length - 1).each do |idx1|
    (idx1...string.length).each do |idx2|
      substrings << string[idx1..idx2]
    end
  end
  substrings
end

def subwords(word, dict)
  subs = substrings(word)
  subs.select { |str| dict.include?(str) }
end
