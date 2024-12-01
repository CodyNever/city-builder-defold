local game_state = require("game.core.game_state")

-- optimization
local insert = table.insert

---@class init_field_handler
---@param state game_state
---@param field_size vector2int
return function(state, field_size)
	assert(field_size)

	local field = {}

	for _ = 1, field_size.x do
		local row = {}
		for _ = 1, field_size.y do
			insert(row, false)
		end

		insert(field, row)
	end

	game_state.set_field(state, field)

	return true
end
