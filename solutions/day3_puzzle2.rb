# --- Part Two ---
# Amidst the chaos, you notice that exactly one claim doesn't overlap by even a
# single square inch of fabric with any other claim. If you can somehow draw
# attention to it, maybe the Elves will be able to make Santa's suit after all!
#
# For example, in the claims above, only claim 3 is intact after all claims are made.
#
# What is the ID of the only claim that doesn't overlap?

length = 10000
fabric = Array.new(length) { Array.new(length, '.') }
input_path = 'input/day3.txt'


File.foreach(input_path) do |line|
  line_array = line.split(' ');
  id = line_array[0].split('#')[1].to_i
  coords = line_array[2].split(',')
  x_coord = coords[0].to_i
  y_coord = coords[1].to_i
  sizes = line_array[3].split('x')
  length_piece = sizes[0].to_i
  height_piece = sizes[1].to_i

  if x_coord+length_piece > length
    new_length = x_coord+length_piece
    fabric[length...new_length] = Array.new(new_length, '.')
    length = new_length
  end
  fabric[x_coord...(x_coord+length_piece)].each_with_index do |sub_array, x|
    sub_array[y_coord...(y_coord+height_piece)].each_with_index do |element, y|
      if element == '.'
        fabric[x_coord + x][y_coord + y] = id
      else
        fabric[x_coord + x][y_coord + y] = 'X'
      end
    end
  end
end

id = 0

File.foreach(input_path) do |line|
  line_array = line.split(' ');
  id = line_array[0].split('#')[1].to_i
  coords = line_array[2].split(',')
  x_coord = coords[0].to_i
  y_coord = coords[1].to_i
  sizes = line_array[3].split('x')
  length_piece = sizes[0].to_i
  height_piece = sizes[1].to_i

  overlapped = fabric[x_coord...(x_coord+length_piece)].any? do |array|
    array[y_coord...(y_coord+height_piece)].any?{|element| element == 'X'}
  end

  break if !overlapped
end

p "the ID of the only claim that doesn't overlap is #{id}"
