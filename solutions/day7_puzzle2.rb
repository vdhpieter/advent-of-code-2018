# --- Part Two ---
# As you're about to begin construction, four of the Elves offer to help. "The sun
# will set soon; it'll go faster if we work together." Now, you need to account for
# multiple people working on steps simultaneously. If multiple steps are available,
# workers should still begin them in alphabetical order.
#
# Each step takes 60 seconds plus an amount corresponding to its letter: A=1, B=2, C=3,
# and so on. So, step A takes 60+1=61 seconds, while step Z takes 60+26=86 seconds.
# No time is required between steps.
#
# To simplify things for the example, however, suppose you only have help from one
# Elf (a total of two workers) and that each step takes 60 fewer seconds (so that
#   step A takes 1 second and step Z takes 26 seconds). Then, using the same
#   instructions as above, this is how each second would be spent:
#
# Second   Worker 1   Worker 2   Done
#    0        C          .
#    1        C          .
#    2        C          .
#    3        A          F       C
#    4        B          F       CA
#    5        B          F       CA
#    6        D          F       CAB
#    7        D          F       CAB
#    8        D          F       CAB
#    9        D          .       CABF
#   10        E          .       CABFD
#   11        E          .       CABFD
#   12        E          .       CABFD
#   13        E          .       CABFD
#   14        E          .       CABFD
#   15        .          .       CABFDE
#
# Each row represents one second of time. The Second column identifies how many
# seconds have passed as of the beginning of that second. Each worker column shows
# the step that worker is currently doing (or . if they are idle). The Done column
# shows completed steps.
#
# Note that the order of the steps has changed; this is because steps now take time
# to finish and multiple workers can begin multiple steps simultaneously.
#
# In this example, it would take 15 seconds for two workers to complete these steps.
#
# With 5 workers and the 60+ second step durations described above, how long will
# it take to complete all of the steps?
input_path = 'input/day7.txt'

MINIMUM_SECONDS = 60

AMOUNT_OF_WORKERS = 5

LETTER_ARRAY = ('A'..'Z').to_a

steps = {}
LETTER_ARRAY.each do |point|
  steps[point] = []
end

File.foreach(input_path) do |line|
  requirement = line[5]
  blocked = line[36]

  steps[blocked].push(requirement)
end

currently_working_on = {}
result = -1

while steps.size > 0 || currently_working_on.size != 0 do
  currently_working_on.each do |current_step, time|
    new_time = time - 1
    currently_working_on[current_step] = new_time

    if time == 0
      steps.each do |step, blockers|
        steps[step] = blockers - [current_step]
      end
      currently_working_on.delete(current_step)
    end
  end

  free_steps = []
  steps.each do |step, blockers|
    if blockers.size == 0
      free_steps.push(step)
    end
  end

  free_steps.sort!
  while(currently_working_on.size < AMOUNT_OF_WORKERS && free_steps.size > 0) do
    start_working_on = free_steps[0]
    time_it_takes = LETTER_ARRAY.find_index(start_working_on) + MINIMUM_SECONDS #+ 1
    currently_working_on[start_working_on] = time_it_takes

    steps.delete(start_working_on)
    free_steps.delete(start_working_on)
  end

  result += 1
end

p "It takes #{result} seconds"
