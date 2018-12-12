# --- Part Two ---
# On the other hand, if the coordinates are safe, maybe the best you can do is try
#   to find a region near as many coordinates as possible.
#
# For example, suppose you want the sum of the Manhattan distance to all of the
# coordinates to be less than 32. For each location, add up the distances to all
# of the given coordinates; if the total of those distances is less than 32, that
# location is within the desired region. Using the same coordinates as above, the
# resulting region looks like this:
#
# ..........
# .A........
# ..........
# ...###..C.
# ..#D###...
# ..###E#...
# .B.###....
# ..........
# ..........
# ........F.
#
# In particular, consider the highlighted location 4,3 located at the top middle of
# the region. Its calculation is as follows, where abs() is the absolute value function:
#
#   Distance to coordinate A: abs(4-1) + abs(3-1) =  5
#   Distance to coordinate B: abs(4-1) + abs(3-6) =  6
#   Distance to coordinate C: abs(4-8) + abs(3-3) =  4
#   Distance to coordinate D: abs(4-3) + abs(3-4) =  2
#   Distance to coordinate E: abs(4-5) + abs(3-5) =  3
#   Distance to coordinate F: abs(4-8) + abs(3-9) = 10
#   Total distance: 5 + 6 + 4 + 2 + 3 + 10 = 30
#
# Because the total distance to all coordinates (30) is less than 32, the location
# is within the region.
#
# This region, which also includes coordinates D and E, has a total size of 16.
#
# Your actual region will need to be much larger than this example, though, instead
# including all locations with a total distance of less than 10000.
#
# What is the size of the region containing all locations which have a total distance
# to all given coordinates of less than 10000?
require 'csv'

input_path = 'input/day6.csv'

MAX_TOTAL_DISTANCE = 10000

points = CSV.read(input_path,
  :headers=>true,
  :header_converters=> lambda {|f| f.strip},
  :converters=> lambda {|f| f ? f.strip : nil}
)

x_values = points['x'].map(&:to_i)
y_values = points['y'].map(&:to_i)

max_x = x_values.max
max_y = y_values.max

map = Array.new(max_x + 1) { Array.new(max_y + 1) }

result = 0

(0..max_x).each do |x|
  (0..max_y).each do |y|
    distances_to_points = []
    points.each.with_index do |point, i|
      distances_to_points.push((point['x'].to_i - x).abs + (point['y'].to_i - y).abs)
    end

    total_distance = distances_to_points.sum

    if total_distance < MAX_TOTAL_DISTANCE
      result += 1
    end
  end
end

p "The size of the safe area is: #{result}."
