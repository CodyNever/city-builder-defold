---@class building
---@field data building_data
---@field coords vector2int[]

---@class building_data
---@field sprite_name string
---@field size vector2int

---@class building_list
---@field buildings building_data[]

---@class game_response
---@field success boolean
---@field response any

---@class game_state
---@field pos2building table<vector2int, building>
---@field buildings building[]
---@field field_bit_map boolean[][]
---@field hero_position vector2int
