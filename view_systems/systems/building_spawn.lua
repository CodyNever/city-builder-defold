local tiny = require("view_systems.tiny")
local grid_math = require("game.utils.grid_math")
local const = require("game.const")

local commands_pool, p0 = tiny.entities_pool_all("spawn_building_command")

---@param world ecs_world
---@param position vector2int
---@param building building_data
local function place_building(world, position, building)
	local positions = grid_math.positions_from_building(building, position)
	local center_position = grid_math.find_center(positions)
	local world_position = grid_math.grid_to_world(center_position)

	world_position.z = grid_math.calculate_sort_order(world_position.y, true)

	local building_entity = {
		building = { building_data = building },
		field_position = { value = position },
		world_position = { value = world_position },
		view = { prefab_key = const.PREFAB_BUILDING, sprite_key = building.sprite_name },
		view_screen_state_changed_flag = {},
	} --[[ @as entity ]]

	tiny.addEntity(world, building_entity)
	tiny.addEntity(world, { force_update_culling_flag = {} })
end

return {
	pools = { p0 },

	---@param world ecs_world
	---@param dt number
	on_tick = function(world, dt)
		for _, entity in ipairs(commands_pool) do
			local command = entity.spawn_building_command--[[ @as component.spawn_building_command ]]
			place_building(world, command.field_position, command.building_data)
			tiny.removeEntity(world, entity)
		end
	end,
}
