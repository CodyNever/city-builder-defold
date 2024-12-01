local tiny = require("view_systems.tiny")

local entities_pool, p0 = tiny.entities_pool_all("move_hero_request", "request_processed_flag")

return {
	pools = { p0 },

	---@param world ecs_world
	---@param dt number
	on_tick = function(world, dt)
		for _, entity in ipairs(entities_pool) do
			world.removeEntity(world, entity)
		end
	end,
}
