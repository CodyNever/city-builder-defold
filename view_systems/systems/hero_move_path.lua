local tiny = require("view_systems.tiny")
local grid_math = require("game.utils.grid_math")
local const = require("game.const")
local create = require("game.utils.create")

local command_pool, p0 = tiny.entities_pool_all("movement_path")

local function create_path(path)
	path.objects = {}

	for i = path.command.current_position, #path.command.positions do
		local grid_position = path.command.positions[i]
		local world_position = grid_math.grid_to_world(grid_position)
		world_position.z = grid_math.calculate_sort_order(world_position.y, true)
		local object_hash = create.object(const.PREFAB_PATH_CIRCLE, world_position)
		table.insert(path.objects, object_hash)
	end
end

local function update_path(path, remaining_circles)
	for _ = 1, #path.objects - remaining_circles do
		go.delete(path.objects[1])
		table.remove(path.objects, 1)
	end
end

local function delete_path(world, path_entity)
	for _, obj in ipairs(path_entity.movement_path.objects) do
		go.delete(obj)
	end

	tiny.removeEntity(world, path_entity)
end

return {
	pools = { p0 },

	---@param world ecs_world
	---@param dt number
	on_tick = function(world, dt)
		for _, path_entity in ipairs(command_pool) do
			local path = path_entity.movement_path --[[ @as component.movement_path ]]

			if path.objects == nil then
				create_path(path)
			end

			local remaining_circles = #path.command.positions - path.command.current_position

			if remaining_circles < 0 then
				delete_path(world, path_entity)
				return
			end

			if #path.objects > remaining_circles then
				update_path(path, remaining_circles)
			end
		end
	end,
}
