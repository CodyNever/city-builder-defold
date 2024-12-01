local const = require("game.const")
local game_state = require("game.core.game_state")

---@class astar_navigation
local M = {}

-- https://github.com/selimanac/defold-astar

function M.setup()
	local map_width = const.FIELD_SIZE.x
	local map_height = const.FIELD_SIZE.y
	local direction = astar.DIRECTION_EIGHT
	local allocate = map_width * map_height
	local typical_adjacent = 8
	local cache = true
	local use_zero = false
	local flip_map = false

	local costs = {
		[0] = {
			1.0, -- E
			1.0, -- N
			1.0, -- W
			1.0, -- S
		},
	}
	astar.setup(map_width, map_height, direction, allocate, typical_adjacent, cache, use_zero, flip_map)
	astar.set_map_type(astar.GRID_CLASSIC)
	astar.set_costs(costs)
end

---@param position vector2int
function M.set_empty(position)
	astar.set_at(position.x, position.y, 0)
end

---@param position vector2int
function M.set_occupied(position)
	astar.set_at(position.x, position.y, 1)
end

---@param from vector2int
---@param to vector2int
---@return boolean
---@return vector2int[]?
function M.try_solve(from, to)
	local status, size, total_cost, path = astar.solve(from.x, from.y, to.x, to.y)

	if status == astar.SOLVED then
		return true, path
	elseif status == astar.NO_SOLUTION then
		return false
	elseif status == astar.START_END_SAME then
		return true, { to }
	end

	return false
end

return M
