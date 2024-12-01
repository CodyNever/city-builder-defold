local tiny = require("view_systems.tiny")
local create = require("game.utils.create")
local const = require("game.const")
local grid_math = require("game.utils.grid_math")

local commands_pool, p0 = tiny.entities_pool_all("create_floating_building_command")
local mouse_position_pool, p1 = tiny.entities_pool_all("mouse_position")
local floating_pool, p2 = tiny.entities_pool_all("floating_building")

---@param world ecs_world
local function delete_unused_floating_buildings(world)
	for i = 1, #floating_pool - 1 do
		go.delete(floating_pool[i].object_hash.hash)
		tiny.removeEntity(world, floating_pool[i])
	end
end

---@param world ecs_world
---@param building_data building_data
local function create_floating_building(world, building_data)
	local world_position = mouse_position_pool[1].mouse_position.world_position
	world_position.z = grid_math.calculate_sort_order(world_position.y, true)

	local object_hash = create.object(const.PREFAB_BUILDING, world_position)

	local path = msg.url(nil, object_hash, "sprite")
	msg.post(path, "play_animation", { id = hash(building_data.sprite_name) })

	local entity = {
		floating_building = { building_data = building_data },
		world_position = { value = world_position },
		object_hash = { hash = object_hash },
	}--[[ @as entity ]]

	tiny.addEntity(world, entity)
end

return {
	pools = { p0, p1, p2 },

	---@param world ecs_world
	---@param dt number
	on_tick = function(world, dt)
		for _, entity in ipairs(commands_pool) do
			if #floating_pool > 1 then
				delete_unused_floating_buildings(world)
			end

			create_floating_building(world, entity.create_floating_building_command.building_data)
			tiny.removeEntity(world, entity)
		end
	end,
}
