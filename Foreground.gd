extends TileMap
var torch_scene = preload("res://TorchLight.tscn")



func place_tile_scenes():
	var torch_tiles = get_used_cells_by_id(0)
	var right_door_tiles = get_used_cells_by_id(4)
	var up_door_tiles = get_used_cells_by_id(2)
	var down_door_tiles = get_used_cells_by_id(3)
	var left_door_tiles = get_used_cells_by_id(1)
	
	
func tiles_instancing(tile_array, tile_scene):
	var current_room = get_parent().grid[Utils.current_room_coords_x][Utils.current_room_coords_y]
	for tile in tile_array:
		var tile_instance = tile_scene.instance()
		tile_instance.position = map_to_world(tile)
		tile_instance.tile = tile
		current_room.add_child(tile_instance)
