module TopK

  class TopArray < Array
    def initialize(max)
      @max = max
    end
    def insert_sort(name, value)
      pos = find_index { |(n,v)| value >= v } || length
      if pos <= @max
        insert(pos, [name, value])
        pop if length > @max
      end
      self
    end
  end

  def self.reduce(k)
    topk = TopArray.new(k)

    total = nil
    prev_key = nil

    ARGF.each do |line|
       key, value = line.chomp.split("\t")

       if key != prev_key
         topk.insert_sort(prev_key, total) unless prev_key.nil?
         total = 0
         prev_key = key
       end
       total += value.to_i
    end

    topk.insert_sort(prev_key, total) unless prev_key.nil?

    topk.each do |(key, value)|
      puts [key, value].join("\t")
    end
  end

end
