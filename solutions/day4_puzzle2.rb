# --- Part Two ---
# Strategy 2: Of all guards, which guard is most frequently asleep on the same minute?
#
# In the example above, Guard #99 spent minute 45 asleep more than any other guard
# or minute - three times in total. (In all other cases, any guard spent any minute
# asleep at most twice.)
#
# What is the ID of the guard you chose multiplied by the minute you chose? (In the
# above example, the answer would be 99 * 45 = 4455.)
def next_line_same_guard_or_empty(i, sorted_lines)
  new_i = i + 1
  new_line = sorted_lines[new_i]
  new_line != nil && !new_line.end_with?("begins shift\n")
end

input_path = 'input/day4.txt'

lines = File.readlines(input_path)
sorted_lines = lines.sort
# Structure:
# {
#   10: { # With the key being the guard id
#     total_minutes_alseep: 55,
#     minutes_per_night: {
#       '11-5': [1, 2, 3, 10, 24] # With the key being the date
#     }
#   }
# }
minutes_alseep_per_guard = {}

i = 0

while(i < sorted_lines.size - 1) # minus 1 for empty line at end of file
  # [1518-11-01 00:00] Guard #10 begins shift
  guard_assignment_array = sorted_lines[i].split(' ')
  guard_id = guard_assignment_array[3].delete('#').to_i

  unless minutes_alseep_per_guard[guard_id]
    minutes_alseep_per_guard[guard_id] = {
      total_minutes_alseep: 0,
      minutes_per_night: {}
    }
  end

  while(next_line_same_guard_or_empty(i, sorted_lines))
    i += 1
    # [1518-11-01 00:05] falls asleep
    falls_asleep_line_array = sorted_lines[i].split(' ')
    time_asleep = falls_asleep_line_array[1].delete(']')
    minute_asleep = time_asleep.split(':')[1].to_i

    i += 1
    # [1518-11-01 00:25] wakes up
    wakes_up_line_array = sorted_lines[i].split(' ')
    time_awake = wakes_up_line_array[1].delete(']')
    minute_awake = time_awake.split(':')[1].to_i

    total_minutes_asleep = minute_awake - minute_asleep
    minutes_alseep_per_guard[guard_id][:total_minutes_alseep] += total_minutes_asleep

    date = falls_asleep_line_array[0].delete('[')
    unless minutes_alseep_per_guard[guard_id][:minutes_per_night][date]
      minutes_alseep_per_guard[guard_id][:minutes_per_night][date] = []
    end
    minutes_alseep_per_guard[guard_id][:minutes_per_night][date]+= (minute_asleep...minute_awake).to_a
  end
  i += 1
end

minutes_alseep_per_guard.each do |key, value|
  all_minutes_in_one_array = []
  value[:minutes_per_night].each do |key2, value2|
    all_minutes_in_one_array += value2
  end

  most_common_minute = all_minutes_in_one_array.max_by { |j| all_minutes_in_one_array.count(j) }
  value[:most_common_minute] = most_common_minute
  value[:count_of_most_common_minute] = all_minutes_in_one_array.count(most_common_minute)
end

guard_with_most_frequent_minute = minutes_alseep_per_guard.max_by do |key, value|
  value[:count_of_most_common_minute]
end

p "The guard that is most asleep is ##{guard_with_most_frequent_minute[0]} "\
  "the minute he is most asleep is #{guard_with_most_frequent_minute[1][:most_common_minute]}. "\
  "He is #{guard_with_most_frequent_minute[1][:count_of_most_common_minute]} times asleep during that minute."\
  "The answer to the  puzzle is: #{guard_with_most_frequent_minute[0] * guard_with_most_frequent_minute[1][:most_common_minute]}"
