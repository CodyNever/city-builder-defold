local tiny = require("view_systems.tiny")
local systems_list = require("view_systems.systems")

---@type function[]
local tick_systems = {}
local world = tiny.world()

local spawn_requests_pool, p0 = tiny.entities_pool_all("spawn_building_request")
local destroy_requests_pool, p1 = tiny.entities_pool_all("destroy_building_request")
local move_hero_pool, p2 = tiny.entities_pool_all("move_hero_request")
local ecs_pools = { p0, p1, p2 }

---@class ecs
local M = {}

function M.init()
	for _, system in ipairs(systems_list) do
		if system.on_init then
			system.on_init(world)
		end

		if system.on_tick then
			table.insert(tick_systems, system.on_tick)
		end

		-- Init pools in TinyECS
		for _, pool in ipairs(system.pools) do
			tiny.addSystem(world, pool)
		end
	end

	-- Init pools in TinyECS
	for _, pool in ipairs(ecs_pools) do
		tiny.addSystem(world, pool)
	end
end

function M.tick(dt)
	-- Tick pools in TinyECS
	tiny.update(world, dt)

	-- Tick systems
	for _, system in ipairs(tick_systems) do
		system(world, dt)
	end
end

function M.finalize()
	tiny.clearEntities(world)
	tiny.clearSystems(world)
end

---@param entity entity
function M.update_entity(entity)
	tiny.addEntity(world, entity)
end

---@param key string
function M.send_key_down(key)
	tiny.addEntity(world, { key_down_event = { key = key } })
end

---@param position vector2
function M.send_mouse_move(position)
	tiny.addEntity(world, { mouse_move_event = { position = position } })
end

---@param position vector2
function M.send_mouse_button_down(position)
	tiny.addEntity(world, { mouse_button_down_event = { position = position } })
end

---@param position vector2
function M.send_mouse_button_up(position)
	tiny.addEntity(world, { mouse_button_up_event = { position = position } })
end

---@param position vector2int
function M.create_field_tile_command(position)
	tiny.addEntity(world, { spawn_tile_command = { field_position = position } })
end

---@param position vector2int
function M.create_camera_command(position)
	tiny.addEntity(world, { spawn_camera_command = { position = position } })
end

---@param position vector2int
function M.create_hero_command(position)
	tiny.addEntity(world, { spawn_hero_command = { position = position } })
end

---@param building_data building_data
---@param position vector2int
function M.create_building_command(building_data, position)
	tiny.addEntity(
		world,
		{ spawn_building_command = {
			building_data = building_data,
			field_position = position,
		} }
	)
end

---@param position vector2int
function M.destroy_building_command(position)
	tiny.addEntity(world, { destroy_building_command = {
		field_position = position,
	} })
end

---@param building_data building_data
function M.create_floating_building_command(building_data)
	tiny.addEntity(world, { create_floating_building_command = { building_data = building_data } })
end

---@param positions vector2int[]
function M.move_hero_command(positions)
	local command = { positions = positions, cooldown = 0, current_position = 1 }
	tiny.addEntity(world, { move_hero_command = command })
	tiny.addEntity(world, { movement_path = { command = command } })
end

---@param building_data building_data
---@param position vector2int
function M.create_building_request(building_data, position)
	tiny.addEntity(
		world,
		{ spawn_building_request = {
			building_data = building_data,
			field_position = position,
		} }
	)
end

---@param position vector2int
function M.destroy_building_request(position)
	tiny.addEntity(world, { destroy_building_request = {
		field_position = position,
	} })
end

---@return entity[]
function M.get_building_creation_requests()
	return spawn_requests_pool
end

---@return entity[]
function M.get_building_destroy_requests()
	return destroy_requests_pool
end

function M.get_move_hero_requests()
	return move_hero_pool
end

return M
