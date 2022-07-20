extends Area2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Area2D_body_entered(body):
	get_parent().get_parent().tile_set.call_deferred("tile_set_modulate", 4, Color(1,1,1,0.4))
	get_parent().get_parent().tile_set.call_deferred("tile_set_modulate", 7, Color(1,1,1,0.4))
	get_parent().get_parent().tile_set.call_deferred("tile_set_modulate", 12, Color(1,1,1,0.4))
	get_parent().get_parent().tile_set.call_deferred("tile_set_modulate", 13, Color(1,1,1,0.4))
	get_parent().get_parent().tile_set.call_deferred("tile_set_modulate", 16, Color(1,1,1,0.4))
	get_parent().get_parent().tile_set.call_deferred("tile_set_modulate", 19, Color(1,1,1,0.4))
	get_parent().get_parent().tile_set.call_deferred("tile_set_modulate", 20, Color(1,1,1,0.4))
	get_parent().get_parent().get_node('YSort/Foreground').tile_set.call_deferred("tile_set_modulate", 3, Color(1,1,1,0.4))


func _on_Area2D_body_exited(body):
	get_parent().get_parent().tile_set.call_deferred("tile_set_modulate", 4, Color(1,1,1,1))
	get_parent().get_parent().tile_set.call_deferred("tile_set_modulate", 7, Color(1,1,1,1))
	get_parent().get_parent().tile_set.call_deferred("tile_set_modulate", 12, Color(1,1,1,1))
	get_parent().get_parent().tile_set.call_deferred("tile_set_modulate", 13, Color(1,1,1,1))
	get_parent().get_parent().tile_set.call_deferred("tile_set_modulate", 16, Color(1,1,1,1))
	get_parent().get_parent().tile_set.call_deferred("tile_set_modulate", 19, Color(1,1,1,1))
	get_parent().get_parent().tile_set.call_deferred("tile_set_modulate", 20, Color(1,1,1,1))
	get_parent().get_parent().get_node('YSort/Foreground').tile_set.call_deferred("tile_set_modulate", 3, Color(1,1,1,1))
