local M = {}

---@param name string
---@param position? vector3
---@param rotation? quaternion
---@param properties? table
---@param scale? number|vector3
---@overload fun(name: string): url
---@return hash
function M.object(name, position, rotation, properties, scale)
	return factory.create("/factories#" .. name, position, rotation, properties, scale)
end

return M
