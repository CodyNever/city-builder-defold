local const = require("game.const")
local game_math = require("game.utils.game_math")
local M = {}

---@param position vector2int|vector2
---@return vector3
function M.grid_to_world(position)
	--https://isometric-tiles.readthedocs.io/en/latest/#equations

	local x = (const.TILE_WIDTH * position.x) / 2
		+ (const.FIELD_SIZE.y * const.TILE_WIDTH) / 2
		- (position.y * const.TILE_WIDTH) / 2

	local y = ((const.FIELD_SIZE.y - position.y - 1) * const.TILE_HEIGHT) / 2
		+ (const.FIELD_SIZE.x * const.TILE_HEIGHT) / 2
		- (position.x * const.TILE_HEIGHT) / 2

	return vmath.vector3(x, y, 0)
end

---@param world_position vector2|vector3
---@return vector2int
function M.world_to_grid(world_position)
	local threshold = 400
	local max_x = const.FIELD_SIZE.x
	local max_y = const.FIELD_SIZE.y
	local total_cells = max_x * max_y

	local best_tile_x, best_tile_y = 1, 1
	local min_dist = math.huge

	local dist_func = game_math.sqr_distance
	local grid2world = M.grid_to_world

	local tile = { x = 1, y = 1 }

	for i = 0, total_cells - 1 do
		tile.x = (i % max_x) + 1
		tile.y = math.floor(i / max_x) + 1

		---@diagnostic disable-next-line: param-type-mismatch
		local dist = dist_func(world_position, grid2world(tile))

		if dist < min_dist then
			min_dist = dist
			best_tile_x = tile.x
			best_tile_y = tile.y

			if dist < threshold then
				return { x = best_tile_x, y = best_tile_y }
			end
		end
	end

	return { x = best_tile_x, y = best_tile_y }
end

---@param building building_data
---@param position vector2int
---@return vector2int[]
function M.positions_from_building(building, position)
	assert(position)

	local positions = {}
	local start = {
		x = position.x - math.floor(building.size.x / 2),
		y = position.y - math.floor(building.size.y / 2),
	}

	for x = 1, building.size.x do
		for y = 1, building.size.y do
			table.insert(positions, { x = start.x + x - 1, y = start.y + y - 1 })
		end
	end

	return positions
end

---@param positions vector2[]|vector2int[]
---@return vector2
function M.find_center(positions)
	assert(positions)

	if #positions == 0 then
		return { x = 0, y = 0 }
	end

	-- Initialize min and max values
	local min_x, max_x = positions[1].x, positions[1].x
	local min_y, max_y = positions[1].y, positions[1].y

	-- Find the min and max for both axes
	for _, pos in ipairs(positions) do
		if pos.x < min_x then
			min_x = pos.x
		end
		if pos.x > max_x then
			max_x = pos.x
		end
		if pos.y < min_y then
			min_y = pos.y
		end
		if pos.y > max_y then
			max_y = pos.y
		end
	end

	-- Calculate the center using the midpoints
	local center_position = {
		x = (min_x + max_x) / 2,
		y = (min_y + max_y) / 2,
	}

	return center_position
end

---@param y number
---@param is_priority boolean
---@return number
function M.calculate_sort_order(y, is_priority)
	local offset = is_priority and 0.1 or 0
	return math.min(math.max(-0.99, (1 / y) + offset), 0.99)
end

return M
