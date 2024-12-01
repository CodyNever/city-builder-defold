local tiny = require("view_systems.tiny")
local const = require("game.const")

local entities_pool, p0 = tiny.entities_pool_all("input_based_movement", "object_hash")
local input_pool, p1 = tiny.entities_pool_all("key_down_event")

local direction_lookup = {
	[const.INPUT_KEY_W] = { x = 0, y = 1 },
	[const.INPUT_KEY_S] = { x = 0, y = -1 },
	[const.INPUT_KEY_A] = { x = -1, y = 0 },
	[const.INPUT_KEY_D] = { x = 1, y = 0 },
}

---@param entities entity[]
---@return vector2int
local function calculate_input_direction(entities)
	local input_direction = { x = 0, y = 0 }
	for _, input_entity in ipairs(entities) do
		local input = input_entity.key_down_event--[[ @as component.key_down_event ]]

		local add = direction_lookup[input.key] or { x = 0, y = 0 }
		input_direction.x = input_direction.x + add.x
		input_direction.y = input_direction.y + add.y
	end
	return input_direction
end

---@param speed number
---@param hash hash
---@param dir vector2int
---@param dt number
local function move_object(speed, hash, dir, dt)
	local pos = go.get_position(hash)
	local vec = vmath.normalize(vmath.vector3(dir.x, dir.y, 1)) --[[@as vector3]]
	local new_pos = vmath.vector3(pos.x + vec.x * dt * speed, pos.y + vec.y * dt * speed, pos.z)
	go.set_position(new_pos, hash)
end

return {
	pools = { p0, p1 },

	---@param world ecs_world
	---@param dt number
	on_tick = function(world, dt)
		if #input_pool == 0 then
			return
		end

		local dir = calculate_input_direction(input_pool)

		for _, entity in ipairs(entities_pool) do
			move_object(entity.input_based_movement.speed, entity.object_hash.hash, dir, dt)
			world.addEntity(world, { camera_moved_event = {} }--[[ @entity ]])
		end
	end,
}
