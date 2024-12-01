local game_state = require("game.core.game_state")
local astar_navigation = require("game.core.astar_navigation")

---@class destroy_building_handler
---@param state game_state
---@param position vector2int
return function(state, position)
	assert(position)

	local building = game_state.get_building(state, position)

	if not building then
		return false
	end

	for _, pos in ipairs(building.coords) do
		game_state.set_field_bit(state, pos, false)
		astar_navigation.set_empty(pos)
	end

	game_state.remove_building(state, position)

	return true, { positions = building.coords }
end
