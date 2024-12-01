local game_state = require("game.core.game_state")
local const = require("game.const")
local grid_math = require("game.utils.grid_math")
local astar_navigation = require("game.core.astar_navigation")

---@class create_building_handler
---@param state game_state
---@param building_data building_data
---@param position vector2int
return function(state, position, building_data)
	assert(position)
	assert(building_data)

	local positions = grid_math.positions_from_building(building_data, position)

	for _, pos in ipairs(positions) do
		if pos.x <= 0 or pos.y <= 0 or pos.x > const.FIELD_SIZE.x or pos.y > const.FIELD_SIZE.y then
			return false, { reason = "Out of field" }
		end

		if game_state.get_field_bit(state, pos) then
			return false, { reason = "Place occuped" }
		end

		local hero_position = game_state.get_hero_position(state)
		if hero_position.x == pos.x and hero_position.y == pos.y then
			return false, { reason = "Place occuped by player" }
		end
	end

	for _, pos in ipairs(positions) do
		game_state.set_field_bit(state, pos, true)
		astar_navigation.set_occupied(pos)
	end

	game_state.push_building(state, building_data, positions)

	return true
end
