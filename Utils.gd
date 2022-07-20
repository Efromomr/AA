extends Node

var current_room_coords_x = 0 setget set_current_rooms_x
var current_room_coords_y = 0 setget set_current_rooms_y

var old_room_coords_x = 0 setget set_old_rooms_x
var old_room_coords_y = 0 setget set_old_rooms_y

var player_movement = Vector2(0,0)

var player setget ,_get_player

func _get_player():
	return player if is_instance_valid(player) else null

func set_current_rooms_x(value):
	current_room_coords_x = int(value)
	
func set_current_rooms_y(value):
	current_room_coords_y = int(value)
	
func set_old_rooms_x(value):
	old_room_coords_x = int(value)
	
func set_old_rooms_y(value):
	old_room_coords_y = int(value)
	
func random_choice(array):
	return array[randi() % array.size()]
	
func spawn_enemy(enemy_name, room, position=Vector2(0,0)):
	var enemy_scene = load("res://Enemies/"+enemy_name+".tscn")
	var instance = enemy_scene.instance()
	room.call_deferred("add_child", instance)
	instance.global_position = get_tree().get_root().get_node("Maze").map_to_world(Vector2(room.x1, room.y1)) + position
