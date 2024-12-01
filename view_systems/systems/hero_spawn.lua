local tiny = require("view_systems.tiny")
local create = require("game.utils.create")
local const = require("game.const")
local grid_math = require("game.utils.grid_math")

local entities_pool, p0 = tiny.entities_pool_all("spawn_hero_command")

---@param world ecs_world
---@param position vector2int
local function spawn_hero(world, position)
	local world_position = grid_math.grid_to_world(position)
	world_position.z = grid_math.calculate_sort_order(world_position.y, true)

	local object_hash = create.object(const.PREFAB_HERO, world_position)

	local hero_entity = {
		field_position = { value = position },
		world_position = { value = world_position },
		object_hash = { hash = object_hash },
		hero = { is_in_move = false },
	}--[[ @as entity ]]

	tiny.addEntity(world, hero_entity)
end

return {
	pools = { p0 },

	---@param world ecs_world
	---@param dt number
	on_tick = function(world, dt)
		for _, entity in ipairs(entities_pool) do
			spawn_hero(world, entity.spawn_hero_command.position)
			tiny.removeEntity(world, entity)
		end
	end,
}
