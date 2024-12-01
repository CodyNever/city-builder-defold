local tiny = require("view_systems.tiny")
local grid_math = require("game.utils.grid_math")

local hero_pool, p0 = tiny.entities_pool_all("hero", "field_position")
local input_pool, p1 = tiny.entities_pool_all("mouse_button_down_event")
local mouse_position_pool, p2 = tiny.entities_pool_all("mouse_position")
local floating_pool, p3 = tiny.entities_pool_all("floating_building")

---@param world ecs_world
---@param hero entity
local function move_hero(world, hero)
	local world_position_v3 = mouse_position_pool[1].mouse_position.world_position
	local world_position = { x = world_position_v3.x, y = world_position_v3.y }--[[ @as vector2 ]]
	local grid_position = grid_math.world_to_grid(world_position)
	local request_entity = { move_hero_request = { position = grid_position } }--[[ @as entity ]]
	world.addEntity(world, request_entity)
end

return {
	pools = { p0, p1, p2, p3 },

	---@param world ecs_world
	---@param dt number
	on_tick = function(world, dt)
		-- No input or floating building in progress
		if #input_pool == 0 or #floating_pool > 0 then
			return
		end

		local hero = hero_pool[1]
		if hero.hero.is_in_move == false then
			move_hero(world, hero)
		end
	end,
}
