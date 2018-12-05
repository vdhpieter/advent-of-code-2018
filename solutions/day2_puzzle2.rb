# --- Part Two ---
# Confident that your list of box IDs is complete, you're ready to find the boxes
# full of prototype fabric.
#
# The boxes will have IDs which differ by exactly one character at the same position
# in both strings. For example, given the following box IDs:
#
# abcde
# fghij
# klmno
# pqrst
# fguij
# axcye
# wvxyz
#
# The IDs abcde and axcye are close, but they differ by two characters (the second
# and fourth). However, the IDs fghij and fguij differ by exactly one character,
# the third (h and u). Those must be the correct boxes.
#
# What letters are common between the two correct box IDs? (In the example above,
# this is found by removing the differing character from either ID, producing fgij.)
require 'csv'

result = ''
found_it = false
input_path = 'input/day2.csv'

CSV.foreach(input_path, headers: false) do |row1|
  string1 = row1[0]
  array1 = string1.split('')

  CSV.foreach(input_path, headers: false) do |row2|
    string2 = row2[0]
    array2 = string2.split('')

    difference = array1 - array2
    next if difference.size > 1

    indeces_with_differences = []
    (1...array1.size).each do |index|
      indeces_with_differences.push(index) if array1[index] != array2[index]
    end

    if indeces_with_differences.size == 1
      array1.delete_at(indeces_with_differences[0])
      result = array1.join
      found_it = true
      break
    end
  end
  break if found_it
end

p "the common letters are: #{result}"
