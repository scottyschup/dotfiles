require "colorize"

class HashCompare
  def compare(a, b, lvl: [], stop: false, verbose: false)
    @verbose = verbose
    @stop = stop
    broken = false
    [a, b].each do |obj|
      next if obj.respond_to? :keys

      err = "ERR: Not a hash: #{obj}"
      puts err.red
      broken = true
      break if @stop
    end
    return false if broken && @stop

    unless (a.keys - b.keys) == [] && (b.keys - a.keys) == []
      label = lvl.empty? ? "Top-level" : lvl.join(".")
      err = "ERR: Keys do not match for #{label}".red
      err += "\n\tExpected: #{a.keys}".yellow
      err += "\n\tGot:      #{b.keys}".yellow
      puts err
      broken = true
    end
    return false if broken && @stop

    a.each_key do |k|
      matches, err = match?(k, a, b, lvl)
      broken = true unless matches
      break if @stop && broken
    end

    (b.keys - a.keys).each do |k|
      matches, err = match?(k, a, b, lvl)
      broken = true unless matches
      break if @stop && broken
    end

    !broken
  end

  def match?(k, a, b, lvl)
    v = a[k]
    v2 = b[k]
    curr_lvl = lvl + [k]
    printf "#{"\t" * curr_lvl.length}#match? #{curr_lvl.join('.')}: "
    if v == v2
      puts "true".green
      [true, nil]
    elsif !a.key?(k) || !b.key?(k)
      err = "ERR: one hash is missing key `#{curr_lvl.join('.')}`"
      puts "false".red
      puts err.red if @verbose
      [false, err]
    elsif v.class != v2.class
      err = "ERR: Mismatched class for #{curr_lvl.join('.')}"
      err += "\n\tExpected: #{v.class}"
      err += "\n\tGot:      #{v2.class}"
      puts err.red if @verbose
      puts "false".red
      [false, err]
    elsif v.is_a?(Hash)
      puts "...comparing child hashes".cyan
      [compare(v, v2, lvl: curr_lvl), nil]
    else
      err = "ERR: Mismatched values for #{curr_lvl.join('.')}"
      err += "\n\tExpected: #{v}"
      err += "\n\tGot:      #{v2}"
      puts "false".red
      puts err.red if @verbose
      [false, err]
    end
  end
end

# Simple tests
hc = HashCompare.new
results = []
small = { a: 1 }
regular = { a: 1, b: 2, c: { d: 4 } }
rearranged_base = { a: 1, c: { d: 4 }, b: 2 }
diff_sub_val = { a: 1, c: { d: 5 }, b: 2 }
diff_sub_type = { a: 1, c: { d: [5] }, b: 2 }
hashes = [
  {
    type: :small,
    data: small,
  }, {
    type: :regular,
    data: regular,
  }, {
    type: :rearranged_base,
    data: rearranged_base,
  }, {
    type: :diff_sub_val,
    data: diff_sub_val,
  }, {
    type: :diff_sub_type,
    data: diff_sub_type,
  },
]

hashes.each_with_index do |info_hash, idx|
  break if idx == hashes.length - 1

  next_info_hash = hashes[idx + 1]

  hash_type = info_hash[:type]
  hash = info_hash[:data]

  next_hash_type = next_info_hash[:type]
  next_hash = next_info_hash[:data]

  puts "\nComparing #{hash_type} to #{next_hash_type}".yellow
  results << hc.compare(hash, next_hash, verbose: true)
end

passed = (results == [false, true, false, false])
color = passed ? :green : :red
puts passed.to_s.colorize(color)
puts "\nFile loaded."
