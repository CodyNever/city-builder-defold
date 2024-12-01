local const = require("game.const")
local buildings_list = require("game.buildings_list")

local M = {}

---@param v0 vector2|vector2int|vector3
---@param v1 vector2|vector2int|vector3
---@return number
function M.sqr_distance(v0, v1)
	return ((v1.x - v0.x) ^ 2) + ((v1.y - v0.y) ^ 2)
end

---@param v0 vector2|vector2int|vector3
---@param v1 vector2|vector2int|vector3
---@return number
function M.distance(v0, v1)
	return math.sqrt((v1.x - v0.x) ^ 2 + (v1.y - v0.y) ^ 2)
end

---@return vector2int
function M.random_position_in_field()
	return { x = math.random(1, const.FIELD_SIZE.x), y = math.random(1, const.FIELD_SIZE.y) }
end

---@return building_data
function M.random_building()
	return buildings_list.buildings[math.random(1, #buildings_list.buildings)]
end

---@param vector vector2|vector2int|vector3
function M.vector_hash(vector)
	return vector.x * 1000000 + vector.y * 1000 + (vector.z or 0)
end

return M
