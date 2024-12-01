return {
	-- clear events & flags
	require("view_systems.systems.input_events_clear"),
	require("view_systems.systems.building_requests_clear"),
	require("view_systems.systems.hero_move_request_clear"),
	require("view_systems.systems.camera_moved_event_clear"),

	-- spawn
	require("view_systems.systems.camera_spawn"),
	require("view_systems.systems.field_tile_spawn"),
	require("view_systems.systems.building_spawn"),
	require("view_systems.systems.hero_spawn"),
	require("view_systems.systems.floating_building_spawn"),
	require("view_systems.systems.floating_building_placer"),
	require("view_systems.systems.hero_move_command"),
	require("view_systems.systems.hero_move_path"),

	-- destroy
	require("view_systems.systems.building_destroy"),

	-- input
	require("view_systems.systems.mouse_position"),
	require("view_systems.systems.building_click_destroy"),
	require("view_systems.systems.hero_move_request"),

	-- tick logic
	require("view_systems.systems.movement"),
	require("view_systems.systems.floating_building_mover"),
	require("view_systems.systems.screen_tracking"),
	require("view_systems.systems.culling"),
}
