local tiny = require("view_systems.tiny")
local camera = require("orthographic.camera")

local mouse_position_pool, p0 = tiny.entities_pool_all("mouse_position")
local input_pool, p1 = tiny.entities_pool_all("mouse_move_event")
local camera_pool, p2 = tiny.entities_pool_all("camera", "object_hash")

---@param world ecs_world
local function create_empty_mouse_position(world)
	tiny.addEntity(world, {
		mouse_position = {
			screen_position = { x = 0, y = 0 },
			world_position = vmath.vector3(),
		},
	})
end

---@param position vector2
local function update_mouse_position(position)
	local screen_coords = position
	local screen_coords_v3 = vmath.vector3(screen_coords.x, screen_coords.y, 0)

	for _, camera_entity in ipairs(camera_pool) do
		local camera_hash = camera_entity.object_hash.hash
		mouse_position_pool[1].mouse_position.screen_position = screen_coords
		mouse_position_pool[1].mouse_position.world_position = camera.screen_to_world(camera_hash, screen_coords_v3)
		return
	end
end

return {
	pools = { p0, p1, p2 },

	---@param world ecs_world
	on_init = function(world)
		create_empty_mouse_position(world)
	end,

	---@param world ecs_world
	on_tick = function(world, _)
		for _, event in ipairs(input_pool) do
			update_mouse_position(event.mouse_move_event.position)
		end
	end,
}
