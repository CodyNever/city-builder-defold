local tiny = require("view_systems.tiny")
local grid_math = require("game.utils.grid_math")

local floating_pool, p0 = tiny.entities_pool_all("floating_building")
local input_pool, p1 = tiny.entities_pool_all("mouse_button_down_event")
local mouse_position_pool, p2 = tiny.entities_pool_all("mouse_position")

---@param world ecs_world
---@param floaitng_entity entity
local function place_buidling(world, floaitng_entity)
	local world_position_v3 = mouse_position_pool[1].mouse_position.world_position
	local world_position = { x = world_position_v3.x, y = world_position_v3.y }--[[ @as vector2 ]]
	local grid_position = grid_math.world_to_grid(world_position)

	tiny.addEntity(world, {
		spawn_building_request = {
			building_data = floaitng_entity.floating_building.building_data,
			field_position = grid_position,
		},
	})

	go.delete(floaitng_entity.object_hash.hash)
	tiny.removeEntity(world, floaitng_entity)
end

return {
	pools = { p0, p1, p2 },

	---@param world ecs_world
	---@param dt number
	on_tick = function(world, dt)
		if #input_pool > 0 then
			for _, floaitng_entity in ipairs(floating_pool) do
				place_buidling(world, floaitng_entity)
			end
		end
	end,
}
