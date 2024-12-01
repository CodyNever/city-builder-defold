local game_math = require("game.utils.game_math")

---@class game_state
local M = {}

---@return game_state
function M.new()
	return {
		pos2building = {},
		buildings = {},
		field_bit_map = { {} },
		hero_position = { x = -1, y = -1 },
	}
end

---@param game_state game_state
---@param building_data building_data
---@param positions vector2int[]
function M.push_building(game_state, building_data, positions)
	assert(building_data)

	local building = { data = building_data, coords = positions }

	table.insert(game_state.buildings, building)

	for _, pos in ipairs(positions) do
		game_state.pos2building[game_math.vector_hash(pos)] = building
	end
end

---@param game_state game_state
---@param position vector2int
function M.remove_building(game_state, position)
	assert(position)

	local building = game_state.pos2building[game_math.vector_hash(position)]
	if building then
		for _, pos in ipairs(building.coords) do
			game_state.pos2building[game_math.vector_hash(pos)] = nil
		end
	end

	for i = 1, #game_state.buildings do
		if game_state.buildings[i] == building then
			table.remove(game_state.buildings, i)
		end
	end
end

---@param game_state game_state
---@param position vector2int
---@return building
function M.get_building(game_state, position)
	return game_state.pos2building[game_math.vector_hash(position)]
end

---@param game_state game_state
---@return vector2int[]
function M.get_buildings_positions(game_state)
	local p = {}
	for _, building in pairs(game_state.buildings) do
		table.insert(p, building.coords[1])
	end
	return p
end

---@param game_state game_state
---@param pos vector2int
---@return boolean
function M.get_field_bit(game_state, pos)
	return game_state.field_bit_map[pos.x][pos.y]
end

---@param game_state game_state
---@param pos vector2int
---@param bit boolean
function M.set_field_bit(game_state, pos, bit)
	game_state.field_bit_map[pos.x][pos.y] = bit
end

---@param game_state game_state
---@param field boolean[][]
function M.set_field(game_state, field)
	game_state.field_bit_map = field
end

---@param game_state game_state
---@return vector2int
function M.get_hero_position(game_state)
	return game_state.hero_position
end

---@param game_state game_state
---@param position vector2int
function M.set_hero_position(game_state, position)
	game_state.hero_position = position
end

return M
