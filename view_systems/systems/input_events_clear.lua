local tiny = require("view_systems.tiny")

local events_pool, p0 =
	tiny.entities_pool_any("mouse_button_down_event", "mouse_button_up_event", "mouse_move_event", "key_down_event")

return {
	pools = { p0 },

	---@param world ecs_world
	---@param dt number
	on_tick = function(world, dt)
		for _, entity in ipairs(events_pool) do
			tiny.removeEntity(world, entity)
		end
	end,
}
