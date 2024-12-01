local tiny = require("view_systems.tiny")
local create = require("game.utils.create")
local const = require("game.const")
local grid_math = require("game.utils.grid_math")
local camera = require("orthographic.camera")

local commands_pool, p0 = tiny.entities_pool_all("spawn_camera_command")

---@param world ecs_world
---@param position vector2int
local function spawn_camera(world, position)
	local world_pos = grid_math.grid_to_world(position)
	local camera_hash = create.object(const.PREFAB_CAMERA, world_pos)

	msg.post(camera_hash, camera.MSG_USE_PROJECTION, { projection = hash("FIXED_AUTO") })

	local camera_entity = {
		camera = {},
		input_based_movement = { speed = const.CAMERA_SPEED },
		object_hash = { hash = camera_hash },
	} --[[@as entity ]]
	tiny.addEntity(world, camera_entity)
end

return {
	pools = { p0 },

	---@param world ecs_world
	---@param dt number
	on_tick = function(world, dt)
		for _, command_entity in ipairs(commands_pool) do
			spawn_camera(world, command_entity.spawn_camera_command.position)
			tiny.removeEntity(world, command_entity)
		end
	end,
}
