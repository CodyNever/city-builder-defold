local tiny = require("view_systems.tiny")
local camera = require("orthographic.camera")
local const = require("game.const")

local view_pool, p0 = tiny.entities_pool_all("view", "world_position")
local event_pool, p1 = tiny.entities_pool_any("camera_moved_event", "force_update_culling_flag")

local function delete_force_update_entities(world)
	for _, entity in ipairs(event_pool) do
		if entity.force_update_culling_flag then
			tiny.removeEntity(world, entity)
		end
	end
end

---@return table
local function calculate_bounds()
	local v4 = camera.screen_to_world_bounds()
	local bounds = {
		top_left = vmath.vector3(v4.x + const.CAMERA_BOUNDS_OFFSET, v4.y + const.CAMERA_BOUNDS_OFFSET, 0),
		top_right = vmath.vector3(v4.z + const.CAMERA_BOUNDS_OFFSET, v4.y + const.CAMERA_BOUNDS_OFFSET, 0),
		bottom_left = vmath.vector3(v4.x - const.CAMERA_BOUNDS_OFFSET, v4.w - const.CAMERA_BOUNDS_OFFSET, 0),
		bottom_right = vmath.vector3(v4.z - const.CAMERA_BOUNDS_OFFSET, v4.w - const.CAMERA_BOUNDS_OFFSET, 0),
	}
	return bounds
end

local function update_view_state(world, bounds, view_entity)
	local pos = view_entity.world_position.value

	local result = pos
		and pos.x >= bounds.bottom_left.x
		and pos.y >= bounds.bottom_left.y
		and pos.x <= bounds.top_right.x
		and pos.y <= bounds.top_right.y

	if view_entity.view.in_screen ~= result then
		view_entity.view.in_screen = result
		view_entity.view_screen_state_changed_flag = {}
		tiny.addEntity(world, view_entity)
	end
end

return {
	pools = { p0, p1 },

	---@param world ecs_world
	---@param dt number
	on_tick = function(world, dt)
		if #event_pool == 0 then
			return
		end
		delete_force_update_entities(world)

		local bounds = calculate_bounds()

		for _, view_entity in ipairs(view_pool) do
			update_view_state(world, bounds, view_entity)
		end
	end,
}
