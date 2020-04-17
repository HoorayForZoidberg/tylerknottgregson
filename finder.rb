# frozen_string_literal: true

def check_snippet(snippet, target_sentence_array)
  # order words last to first (because snippets are found using the last word)
  # memoize the index marking the last word (start with snippet length)
  upper_boundary = snippet.length

  count = 0
  # for each word, find the highest matching index of occurence that is strictly
  # lower than the memoized value, replace it with *** word ***, and keep count
  target_sentence_array.reverse.each do |word|
    matches = snippet[0...upper_boundary].each_index.select { |i| snippet[i].include?(word) }
    unless matches.empty?
      snippet[matches.last] = "#{snippet[matches.last].upcase}"
      upper_boundary = matches.last
      count += 1
    end
  end
  # compare count to target_sentence_array count
  # if they match, return the snippet_arr.join
  # else, return nil
  count == target_sentence_array.length ? snippet.join(' ') : nil
end

puts "Type all your sentences, then type \"go\"\n"
sentences = []
answer = gets.chomp!.downcase
while answer != "go"
  sentences << answer
  answer = gets.chomp!.downcase
end

# get text, remove punctation
text = File.read('greatexpectations.txt')
            .gsub(/([^\s\w’-])/, '')
            .gsub(/\-/, ' ')
            .downcase
            .split(' ')

success = 0

sentences.each do |target_sentence|
  # turn sentence into array
  target_sentence_array = target_sentence.split(' ')

  # start search using last word (less likely to be common)
  search_word = target_sentence_array.last

  # find index of each occurence of last word
  indices = text.each_index.select { |i| text[i].include?(search_word) }

  # for each last word
  indices.each do |i|
    # collect 300 words before
    snippet = text[i - 300..i]
    # check if the passage contains all words in the proper order
    checked_snippet = check_snippet(snippet, target_sentence_array)
    unless checked_snippet.nil?
      puts "\nall words found for #{target_sentence}: \n  #{checked_snippet}"
      success += 1
    end
  end
end

success.positive? ? puts("\nfound in #{success} instances") : puts('sorry, no luck')
