local game_state = require("game.core.game_state")
local astar_navigation = require("game.core.astar_navigation")
local const = require("game.const")

---@class move_hero_handler
---@param state game_state
---@param position vector2int
return function(state, position)
	assert(position)

	if position.x < 0 or position.y < 0 or position.x > const.FIELD_SIZE.x or position.y > const.FIELD_SIZE.y then
		return false, { reason = "Taget position out of field" }
	end

	if game_state.get_field_bit(state, position) then
		return false
	end

	local current_position = game_state.get_hero_position(state)
	local success, path = astar_navigation.try_solve(current_position, position)

	if success and path then
		game_state.set_hero_position(state, position)

		return true, { path = path }
	end

	return false, { reason = "Can't reach the target position" }
end
