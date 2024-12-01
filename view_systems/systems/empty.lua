local tiny = require("view_systems.tiny")

local entities_pool, p0 = tiny.entities_pool_all()

return {
	pools = { p0 },

	---@param world ecs_world
	on_init = function(world) end,

	---@param world ecs_world
	---@param dt number
	on_tick = function(world, dt)
		for _, entity in ipairs(entities_pool) do
		end
	end,
}
