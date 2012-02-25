#!/usr/bin/env ruby -wKU

abort("Usage: #{$0} PATTERNS_FILE DICTIONARY_FILE") if ARGV.size != 2

File.open(ARGV[0], 'r') do |file|
  while line = file.gets do
    line.split.each do |pattern_str|
      pattern_str.downcase!
      pattern_frq = {}
      position = 0
      pattern_str.each_char do |char|
        pattern_frq[char] ||= Array.new 
        pattern_frq[char] << position
        position += 1
      end

      matching_words = []
      
      File.open(ARGV[1], 'r') do |dict|
        while dict_word = dict.gets do
          dict_word.strip!.downcase!
          next if dict_word.size != pattern_str.size
          match = true
          checked_symbols = []
          pattern_frq.each do |symbol, positions|
            current_symbol = dict_word[positions[0]]
            positions.each do |pos|
              if current_symbol != dict_word[pos] or checked_symbols.include?(current_symbol)
                match = false
                break
              end
            end
            break if !match
            checked_symbols << current_symbol
          end
          matching_words << dict_word if match
        end
      end

      if !matching_words.empty?
        puts "Possible matches for #{pattern_str} are #{matching_words}"
      end
    end
  end
end
          
