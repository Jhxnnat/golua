-- Game of Life Implementation
-- 1: live cell; 0: dead cell;

w = 10
size = w*w
grid = {}
helper_grid = {}
iterations = 100

function fill_grids()
	for i = 1, size do
		grid[i] = 0
		helper_grid[i] = 0
	end

	local center = (w * (w/2 - 1)) + (w / 2)
	grid[center] = 1
	grid[center+w-1] = 1
	grid[center+w] = 1
	grid[center+w+w] = 1
	grid[center+w+w+1] = 1
end

function on_edge(index)
	if index <= w+1 then return true end
	if index >= size-w then return true end
	if index % w == 0 then return true end
	if (index-1) % w == 0 then return true end
	return false
end

function print_grid()
	print()
	for i = 1, size do
		if not on_edge(i) then
			if grid[i] == 0 then 
				io.write("  ", " ")
			else 
				io.write("  ", "o")
			end
		else
			io.write("  *")
		end
		if i % w == 0 then print() end
	end
	print()
end

function check_around(index)
	-- we dont need that since edge are not checked in the first place
	local i = 0
	i = i + grid[index-w] --top
	i = i + grid[index-w+1] --top right
	i = i + grid[index+1] --right
	i = i + grid[index+w+1] --bottom right
	i = i + grid[index+w] --bottom
	i = i + grid[index+w-1] --bottom left
	i = i + grid[index-1] --left
	i = i + grid[index-w-1] --top left
	return i
end

function perform(amount, value) --check if cells should die, born or remain
	-- Any live cell with fewer than two live neighbours dies, as if by underpopulation.
	-- Any live cell with two or three live neighbours lives on to the next generation.
	-- Any live cell with more than three live neighbours dies, as if by overpopulation.
	-- Any dead cell with exactly three live neighbours becomes a live cell, as if by reproduction.
	if value == 0 then
		if amount == 3 then return 1 end
	else
		if amount < 2 then return 0 end
		if amount > 3 then return 0 end
		if amount >= 2 and amount <= 3 then return 1 end
	end
	return value
end

function cycle() --do the life cycle
	for i = w+1, size-w do
		if not on_edge(i) then
			local neighbours = check_around(i)
			helper_grid[i] = perform(neighbours, grid[i])
		end
	end
	table.move(helper_grid, 1, #helper_grid, 1, grid)
end

automode = false
reset = false
quit = false

function read_input(opt)
	if opt == 'a' then automode = true
	elseif opt == 'r' then reset = true
	elseif opt == 'q' then quit = true end
end

function loop() 
	fill_grids()
	for i = 0, iterations do
		if quit then break end
		if reset then
			reset = false
			fill_grids()
			i = 0
		else
			os.execute("clear")
			print_grid()
			cycle()
			if not automode then
				print()
				io.write(">> a: automode; r: reset; q: quit; \notherwise continue-> ")
				local wait = io.read()
				read_input(wait)
			else
				os.execute("sleep 0.4")
			end
		end
	end
end

loop()

