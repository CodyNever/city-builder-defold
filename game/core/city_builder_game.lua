local const = require("game.const")
local game_state = require("game.core.game_state")

local init_field_handler = require("game.handlers.init_field_handler")
local create_building_handler = require("game.handlers.create_building_handler")
local destroy_building_handler = require("game.handlers.destroy_building_handler")
local create_hero_handler = require("game.handlers.create_hero_handler")
local move_hero_handler = require("game.handlers.move_hero_handler")

---@type table<string, function>
local handlers = {
	[const.REQUEST_INIT_FIELD_KEY] = init_field_handler,
	[const.REQUEST_CREATE_BUILDING_KEY] = create_building_handler,
	[const.REQUEST_DESTROY_BUILDING_KEY] = destroy_building_handler,
	[const.REQUEST_CREATE_HERO_KEY] = create_hero_handler,
	[const.REQUEST_MOVE_HERO_KEY] = move_hero_handler,
}

---@type table<string, url[]>
local event_listeners = {}

---@class city_builder_game
---@field session_state game_state
local M = {}

M.session_state = game_state.new()

---@param key string
---@return game_response
function M.send(key, ...)
	local handler = handlers[key]
	assert(handler, "Handler not registered for: " .. key)

	local result, success, response = pcall(handler, M.session_state, ...)
	if not result then
		print("Error during handler execution: " .. key)
		print(success)
		return { success = false }
	end

	local body = { success = success, response = response or {} }
	if event_listeners[key] then
		-- event dispatch
		for _, id in ipairs(event_listeners[key]) do
			print("event dispatch")
			msg.post(id, key, { success = success, error = body.response.reason })
		end
	end

	return body
end

---@param key string
---@param listener url
function M.add_listener(key, listener)
	if event_listeners[key] == nil then
		event_listeners[key] = { listener }
	else
		table.insert(event_listeners[key], listener)
	end
end

---@param key string
---@param listener url
function M.remove_listener(key, listener)
	if event_listeners[key] then
		for i, other in ipairs(event_listeners[key]) do
			if other == listener then
				table.remove(event_listeners[key], i)
				return
			end
		end
	end
end

return M
