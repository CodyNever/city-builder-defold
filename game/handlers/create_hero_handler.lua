local game_state = require("game.core.game_state")

---@class create_hero_handler
---@param state game_state
---@param position vector2int
return function(state, position)
	assert(position)
	game_state.set_hero_position(state, position)
	return true
end
