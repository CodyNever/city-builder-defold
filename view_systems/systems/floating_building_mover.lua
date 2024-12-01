local tiny = require("view_systems.tiny")
local grid_math = require("game.utils.grid_math")

local building_pool, p0 = tiny.entities_pool_all("floating_building", "world_position", "object_hash")
local mouse_position_pool, p1 = tiny.entities_pool_all("mouse_position")

return {
	pools = { p0, p1 },

	---@param world ecs_world
	---@param dt number
	on_tick = function(world, dt)
		local mouse_position = mouse_position_pool[1].mouse_position.world_position
		mouse_position.z = grid_math.calculate_sort_order(mouse_position.y, true)

		for _, building in ipairs(building_pool) do
			go.set_position(mouse_position, building.object_hash.hash)
			building.world_position.value = mouse_position
		end
	end,
}
