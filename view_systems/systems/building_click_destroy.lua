local tiny = require("view_systems.tiny")
local grid_math = require("game.utils.grid_math")

local input_pool, p0 = tiny.entities_pool_all("mouse_button_down_event")
local mouse_position_pool, p1 = tiny.entities_pool_all("mouse_position")
local floating_pool, p2 = tiny.entities_pool_all("floating_building")

---@param world ecs_world
---@param world_position vector3
local function try_destroy(world, world_position)
	local grid_position = grid_math.world_to_grid(world_position)
	local request_entity = { destroy_building_request = { field_position = grid_position } }--[[ @as entity ]]
	world.addEntity(world, request_entity)
end

return {
	pools = { p0, p1, p2 },

	---@param world ecs_world
	---@param dt number
	on_tick = function(world, dt)
		-- No input or floating building in progress
		if #input_pool == 0 or #floating_pool > 0 then
			return
		end

		try_destroy(world, mouse_position_pool[1].mouse_position.world_position)
	end,
}
