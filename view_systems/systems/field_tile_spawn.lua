local tiny = require("view_systems.tiny")
local const = require("game.const")
local grid_math = require("game.utils.grid_math")

local commands_pool, p0 = tiny.entities_pool_all("spawn_tile_command")

local function spawn_tile(world, position)
	local world_position = grid_math.grid_to_world(position)
	world_position.z = grid_math.calculate_sort_order(world_position.y, false)

	local field_tile = {
		field_tile = {},
		field_position = { value = position },
		world_position = { value = world_position },
		view = { prefab_key = const.PREFAB_TILE },
		view_screen_state_changed_flag = {},
	}--[[ @as entity ]]

	tiny.addEntity(world, field_tile)
	tiny.addEntity(world, { force_update_culling_flag = {} })
end

return {
	pools = { p0 },

	---@param world ecs_world
	---@param dt number
	on_tick = function(world, dt)
		for _, command_entity in ipairs(commands_pool) do
			spawn_tile(world, command_entity.spawn_tile_command.field_position)
			tiny.removeEntity(world, command_entity)
		end
	end,
}
