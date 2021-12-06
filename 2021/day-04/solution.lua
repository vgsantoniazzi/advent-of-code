function read(file)
   local lines = {}
   for line in io.lines(file) do
      lines[#lines+1] = line
   end
   return lines
end

function split(string, regex)
   local default_regex = "[^%s]+"
   regex = regex or default_regex
   local tokens = {}
   for token in string.gmatch(string, regex) do
      tokens[#tokens+1] = token
   end
   return tokens
end

function get_boards(content)
   local boards = {}
   local boards_count = 0
   local lines_count = 0
   for index, value in pairs(content) do
      if index > 2 then
         lines_count = lines_count + 1
         if math.fmod(index + 3, 6) == 0 then
            boards[boards_count + 1] = {}
            boards_count = boards_count + 1
         end
         if value ~= '' then
            boards[boards_count][math.fmod(index + 3, 6) + 1] = split(value)
         end
      end
   end
   return boards
end

function get_marks(boards)
   local marks = {}
   for board_number, board in pairs(boards) do
      marks[board_number] = {}
      for line, values in pairs(board) do
         marks[board_number][line] = {}
         for column, value in pairs(values) do
            marks[board_number][line][column] = 0
         end
      end
   end
   return marks
end

function print_boards(boards, marks)
   for board_number, board in pairs(boards) do
      print()
      for line, values in pairs(board) do
         io.write(board_number, " ", line, " -> ")
         for column, value in pairs(values) do
            io.write(value, "(", marks[board_number][line][column], ") ")
         end
         print()
      end
   end
end

function mark_number(number, boards, marks)
   for board_number, board in pairs(boards) do
      for line, values in pairs(board) do
         for column, value in pairs(values) do
            if number == value then
               marks[board_number][line][column] = 1
            end
         end
      end
   end
end

function check_for_winner(boards, marks)
   for board_number, board in pairs(boards) do
      value_counter = 0
      winner = false
      for line, values in pairs(board) do
         column_counter = 0
         for column, value in pairs(values) do
            if marks[board_number][line][column] == 1 then
               column_counter = column_counter + 1
            else
               value_counter = value_counter + boards[board_number][line][column]
            end
         end
         if column_counter == 5 then
            winner = true
         end
      end

      for line, values in pairs(board) do
         line_counter = 0
         for column, value in pairs(values) do
            if marks[board_number][column][line] == 1 then
               line_counter = line_counter + 1
            end
         end
         if line_counter == 5 then
            winner = true
         end
      end

      if winner then
         table.remove(marks, board_number)
         table.remove(boards, board_number)
         last_value_count = value_counter
      end
   end
   return last_value_count
end

content = read('input.txt')

local chosen = split(content[1], "[%d]+")
local boards = get_boards(content)
local marks = get_marks(boards)
first_winner = false

for index, number in pairs(chosen) do
   mark_number(number, boards, marks)
   winner_value = check_for_winner(boards, marks)
   if winner_value then
      if not first_winner then
         first_winner = true
         print("winner!", number * winner_value)
      elseif #boards == 0 then
         print("last winner!", number * winner_value)
         break
      end
   end
end
