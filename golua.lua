-- Game of Life Implementation
-- 1: live cell; 0: dead cell;
w = 10
size = w*w
grid = {}
helper_grid = {}
iterations = 100
-- fill grids
for i = 1, size do
	-- grid[i] = math.random(0, 1)
	grid[i] = 0
	helper_grid[i] = 0
end
grid[26] = 1
grid[35] = 1
grid[36] = 1
grid[46] = 1
grid[47] = 1

function shallowCopy(original)
    local copy = {}
    for key, value in pairs(original) do
        copy[key] = value
    end
    return copy
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
	-- dont actually need that since edge are not checked in the first place
	-- if index <= 5 or index >= size+1-5 then return 0 end
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

function perform(amount, value)
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

function cycle()
	for i = w+1, size-w do
		if not on_edge(i) then
			local neighbours = check_around(i)
			helper_grid[i] = perform(neighbours, grid[i])
		end
	end
	table.move(helper_grid, 1, #helper_grid, 1, grid)
end

function loop() 
	for i = 0, iterations do
		os.execute("clear")
		print_grid()
		os.execute("sleep 0.4")
		cycle()
		print()
		--local wait = io.read()
	end
end

loop()

