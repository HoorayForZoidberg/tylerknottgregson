# frozen_string_literal: true

def check_snippet(snippet, target_sentence_array)
  index = snippet.find_index { |word| word.include?(target_sentence_array.first) }

  return false if index.nil?

  return true unless target_sentence_array.length > 1

  new_target_sentence_array = target_sentence_array[1..-1]
  check_snippet(snippet[index + 1..-1], new_target_sentence_array)
end

puts "What sentence are you looking to build?\n"
desired_sentence = gets.chomp!.downcase
target_sentence_array = desired_sentence.split(' ')

# get text, remove punctation
text = File.read('greatexpectations.txt').gsub(/([^\s\w’])|(’\w)/, '').downcase.split(' ')

# start search using last word (less likely to be common)
search_word = target_sentence_array.last

# find index of each occurence of last word
indices = text.each_index.select { |i| text[i].include?(search_word) }

success = 0

# for each index
indices.each do |i|
  # collect 200 words before
  snippet = text[i - 200..i]
  # check if the passage contains all words in the proper order
  if check_snippet(snippet, target_sentence_array)
    puts "\nall words found in following: \n  #{text[i - 200..i].join(' ')}"
    success += 1
  end
end

success.positive? ? puts("\nfound in #{success} instances") : puts('sorry, no luck')
