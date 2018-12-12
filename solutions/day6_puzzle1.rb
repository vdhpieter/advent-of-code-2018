# --- Day 6: Chronal Coordinates ---
# The device on your wrist beeps several times, and once again you feel like you're falling.
#
# "Situation critical," the device announces. "Destination indeterminate. Chronal
# interference detected. Please specify new target coordinates."
#
# The device then produces a list of coordinates (your puzzle input). Are they places
# it thinks are safe or dangerous? It recommends you check manual page 729. The Elves did not give you a manual.
#
# If they're dangerous, maybe you can minimize the danger by finding the coordinate
# that gives the largest distance from the other points.
#
# Using only the Manhattan distance, determine the area around each coordinate by
# counting the number of integer X,Y locations that are closest to that coordinate
# (and aren't tied in distance to any other coordinate).
#
# Your goal is to find the size of the largest area that isn't infinite. For example,
# consider the following list of coordinates:
#
# 1, 1
# 1, 6
# 8, 3
# 3, 4
# 5, 5
# 8, 9
#
# If we name these coordinates A through F, we can draw them on a grid, putting 0,0
# at the top left:
#
# ..........
# .A........
# ..........
# ........C.
# ...D......
# .....E....
# .B........
# ..........
# ..........
# ........F.
#
# This view is partial - the actual grid extends infinitely in all directions. Using the
# Manhattan distance, each location's closest coordinate can be determined, shown here in lowercase:
#
# aaaaa.cccc
# aAaaa.cccc
# aaaddecccc
# aadddeccCc
# ..dDdeeccc
# bb.deEeecc
# bBb.eeee..
# bbb.eeefff
# bbb.eeffff
# bbb.ffffFf
#
# Locations shown as . are equally far from two or more coordinates, and so they
# don't count as being closest to any.
#
# In this example, the areas of coordinates A, B, C, and F are infinite - while not
# shown here, their areas extend forever outside the visible grid. However, the areas
# of coordinates D and E are finite: D is closest to 9 locations, and E is closest
# to 17 (both including the coordinate's location itself). Therefore, in this example,
# the size of the largest area is 17.
#
# What is the size of the largest area that isn't infinite?
require 'csv'

input_path = 'input/day6.csv'

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

(0..max_x).each do |x|
  (0..max_y).each do |y|
    distances_to_points = {}
    points.each.with_index do |point, i|
      distances_to_points[i] = (point['x'].to_i - x).abs + (point['y'].to_i - y).abs
    end

    winning_point = distances_to_points.min_by { |index, distance| distance }

    points_with_winning_distance = distances_to_points.select do |index, distance|
      distance == winning_point[1]
    end

    if points_with_winning_distance.size == 1
      map[x][y] = winning_point[0]
    end
  end
end

points_to_check = (0...points.size).to_a
transposed_map = map.transpose
points_to_remove = map[0] + map[max_x] + transposed_map[0] + transposed_map[max_y]
points_to_check -= points_to_remove

area_sizes = {}
points_to_check.each do |point_index|
  area_sizes[point_index] = map.sum do |row|
    row.count(point_index)
  end
end

p area_sizes

result = area_sizes.max_by { |point_index, area_size| area_size }

p "The size of largest area that isn't infinite is #{result[1]} and it is for point #{result[0]}."
