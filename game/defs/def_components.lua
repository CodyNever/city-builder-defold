
-- "command" refers to a request made to the ECS view
-- "request" refers to a request made to the game logic

------------------------ Basic ------------------------

---@class component.field_position
---@field value vector2int

---@class component.world_position
---@field value vector3

---@class component.object_hash
---@field hash hash

---@class component.view
---@field prefab_key string
---@field sprite_key string?
---@field in_screen boolean?

------------------------ Logic ------------------------

---@class component.input_based_movement
---@field speed number

---@class component.mouse_position
---@field screen_position vector2
---@field world_position vector3

------------------------ Objects ------------------------

---@class component.field_tile

---@class component.camera

---@class component.building
---@field building_data building_data

---@class component.hero
---@field is_in_move boolean

---@class component.floating_building
---@field building_data building_data

---@class component.movement_path
---@field objects hash[]?
---@field command component.move_hero_command

------------------------ Commands ------------------------

---@class component.spawn_tile_command
---@field field_position vector2int

---@class component.spawn_camera_command
---@field position vector2int

---@class component.spawn_hero_command
---@field position vector2int

---@class component.spawn_building_command
---@field field_position vector2int
---@field building_data building_data

---@class component.destroy_building_command
---@field field_position vector2int

---@class component.create_floating_building_command
---@field building_data building_data

---@class component.move_hero_command
---@field positions vector2int[]
---@field current_position integer
---@field cooldown number

------------------------ Requests ------------------------

---@class component.spawn_building_request
---@field field_position vector2int
---@field building_data building_data

---@class component.destroy_building_request
---@field field_position vector2int

---@class component.move_hero_request
---@field position vector2int

------------------------ Flags ------------------------
---@class component.view_screen_state_changed_flag

---@class component.request_processed_flag

---@class component.force_update_culling_flag

------------------------ Events ------------------------

---@class component.mouse_button_down_event
---@field position vector2

---@class component.mouse_button_up_event
---@field position vector2

---@class component.mouse_move_event
---@field position vector2

---@class component.key_down_event
---@field key string

---@class component.camera_moved_event
