local tiny = require("view_systems.tiny")
local create = require("game.utils.create")

local entities_pool, p0 = tiny.entities_pool_all("view", "world_position", "view_screen_state_changed_flag")

---@param entity entity
local function create_view(entity)
	local pos = entity.world_position.value
	local object_hash = create.object(entity.view.prefab_key, pos)
	entity.object_hash = { hash = object_hash }

	if entity.view.sprite_key then
		local path = msg.url(nil, object_hash, "sprite")
		msg.post(path, "play_animation", { id = hash(entity.view.sprite_key) })
	end
end

local function destroy_view(entity)
	go.delete(entity.object_hash.hash)
	entity.object_hash = nil
end

return {
	pools = { p0 },

	---@param world ecs_world
	---@param dt number
	on_tick = function(world, dt)
		for _, entity in ipairs(entities_pool) do
			local view = entity.view --[[ @as component.view ]]

			-- Create
			if view.in_screen and not entity.object_hash then
				create_view(entity)
			end

			-- Destroy
			if not view.in_screen and entity.object_hash then
				destroy_view(entity)
			end

			-- Update in ecs
			entity.view_screen_state_changed_flag = nil
			tiny.addEntity(world, entity)
		end
	end,
}
