local tiny = require("view_systems.tiny")
local grid_math = require("game.utils.grid_math")
local const = require("game.const")

local hero_pool, p0 = tiny.entities_pool_all("hero", "field_position", "world_position")
local command_pool, p1 = tiny.entities_pool_all("move_hero_command")

---@param hero entity
---@param position vector2int
local function move_hero(hero, position)
	local world_position = grid_math.grid_to_world(position)
	world_position.z = grid_math.calculate_sort_order(world_position.y, true)

	hero.field_position.value = position
	hero.world_position.value = world_position
	hero.hero.is_in_move = true

	go.set_position(world_position, hero.object_hash.hash)
end

---@param command component.move_hero_command
---@param hero entity
---@param dt number
local function process_command(command, hero, dt)
	command.cooldown = command.cooldown - dt

	if command.cooldown <= 0 then
		command.cooldown = const.DELAY_BETWEEN_HERO_MOVE
		command.current_position = command.current_position + 1

		if command.current_position > #command.positions then
			return false
		end

		move_hero(hero, command.positions[command.current_position])
	end

	return true
end

return {
	pools = { p0, p1 },

	---@param world ecs_world
	---@param dt number
	on_tick = function(world, dt)
		local hero = hero_pool[1]
		if not hero then
			return
		end

		for _, command_entity in ipairs(command_pool) do
			local command = command_entity.move_hero_command --[[ @as component.move_hero_command ]]

			if not process_command(command, hero, dt) then
				tiny.removeEntity(world, command_entity)
				hero.hero.is_in_move = false
				break
			end
		end
	end,
}
