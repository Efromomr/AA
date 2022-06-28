extends Area2D

var direction = Vector2.DOWN




# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Exit_body_entered(body):
	Utils.old_room_coords_x = Utils.current_room_coords_x
	Utils.old_room_coords_y = Utils.current_room_coords_y
	Utils.current_room_coords_x += int(direction.x)
	Utils.current_room_coords_y += int(direction.y)
	Utils.player_movement = direction
	get_tree().get_root().get_node("Maze").get_fixed_rooms()
	queue_free()
	
