# --- Part Two ---
# Time to improve the polymer.
#
# One of the unit types is causing problems; it's preventing the polymer from
# collapsing as much as it should. Your goal is to figure out which unit type is
# causing the most problems, remove all instances of it (regardless of polarity),
# fully react the remaining polymer, and measure its length.
#
# For example, again using the polymer dabAcCaCBAcCcaDA from above:
#
# Removing all A/a units produces dbcCCBcCcD. Fully reacting this polymer produces dbCBcD, which has length 6.
# Removing all B/b units produces daAcCaCAcCcaDA. Fully reacting this polymer produces daCAcaDA, which has length 8.
# Removing all C/c units produces dabAaBAaDA. Fully reacting this polymer produces daDA, which has length 4.
# Removing all D/d units produces abAcCaCBAcCcaA. Fully reacting this polymer produces abCBAc, which has length 6.
#
# In this example, removing all C/c units was best, producing the answer 4.
#
# What is the length of the shortest polymer you can produce by removing all units
# of exactly one type and fully reacting the result?
input_path = 'input/day5.txt'

start_polymer = File.binread(input_path).delete("\n")

results_per_letter = {}

('a'..'z').each do |letter|
  p "working on #{letter.swapcase}/#{letter}"
  polymer = start_polymer.delete("#{letter}#{letter.swapcase}")
  start_size = polymer.size
  end_size = 0

  while(start_size > end_size)
    start_size = polymer.size
    result_polymer = polymer

    polymer.each_char.with_index do |char, index|
      next_char = polymer[index+1]
      break unless next_char
      if (char == next_char.swapcase)
        result_polymer.slice!("#{char}#{next_char}")
      end
    end

    end_size = result_polymer.size
    polymer = result_polymer
  end

  results_per_letter[letter] = polymer.size
end

best_letter = results_per_letter.min_by { |key, value| value }

p "With removing polymer pair #{best_letter[0].swapcase}/#{best_letter[0]} we remain with "\
  "a polymer with length #{best_letter[1]}"
