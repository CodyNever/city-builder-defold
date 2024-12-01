local tiny = require("view_systems.tiny")

local events_pool, p0 = tiny.entities_pool_all("camera_moved_event")

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
