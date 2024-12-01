local tiny = require("view_systems.tiny")
local create = require("game.utils.create")
local const = require("game.const")

local buildings_pool, p0 = tiny.entities_pool_all("building")
local commands_pool, p1 = tiny.entities_pool_all("destroy_building_command")

---@param position vector3
local function create_explosion(position)
	local expl = create.object(const.PREFAB_EXPLOSION, position)

	local sprite_url = msg.url(nil, expl, "sprite")
	sprite.play_flipbook(sprite_url, hash("boom"), function(_, _, _, sender)
		go.delete(sender)
	end)
end

---@param world ecs_world
---@param building entity
local function destroy_building(world, building)
	if building.object_hash then
		local position = go.get_position(building.object_hash.hash)
		create_explosion(position)

		go.delete(building.object_hash)
	end

	tiny.removeEntity(world, building)
end

---@param world ecs_world
---@param position vector2int
local function destroy_by_position(world, position)
	for _, building in ipairs(buildings_pool) do
		local building_position = building.field_position.value

		if building_position.x == position.x and building_position.y == position.y then
			destroy_building(world, building)
			return
		end
	end
end

return {
	pools = { p0, p1 },

	---@param world ecs_world
	---@param dt number
	on_tick = function(world, dt)
		for _, entity in ipairs(commands_pool) do
			local destroy_position = entity.destroy_building_command.field_position
			destroy_by_position(world, destroy_position)
			tiny.removeEntity(world, entity)
		end
	end,
}
