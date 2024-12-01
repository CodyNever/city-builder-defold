local tiny = require("view_systems.tiny")

local spawn_pool, p0 = tiny.entities_pool_all("spawn_building_request", "request_processed_flag")
local destroy_pool, p1 = tiny.entities_pool_all("destroy_building_request", "request_processed_flag")

return {
	pools = { p0, p1 },

	---@param world ecs_world
	---@param dt number
	on_tick = function(world, dt)
		for _, entity in ipairs(spawn_pool) do
			tiny.removeEntity(world, entity)
		end

		for _, entity in ipairs(destroy_pool) do
			tiny.removeEntity(world, entity)
		end
	end,
}
