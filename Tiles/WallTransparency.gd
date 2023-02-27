extends Area2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

var transparent_count = 0 setget set_trans
var transparent = false


func set_trans(value):
	transparent_count = value
	if not transparent and transparent_count > 0:
		transparent = true
		change_transparency()
	elif transparent and transparent_count < 1:
		transparent = false
		change_transparency()
	


func _on_DownWall_area_entered(area):
	self.transparent_count = transparent_count+ 1


func _on_DownWall_area_exited(area):
	self.transparent_count = transparent_count- 1
	
func change_transparency():
	if not transparent:
		for i in range(7):
			get_parent().get_parent().tile_set.call_deferred("tile_set_modulate", 4, Color(1,1,1,0.4+0.1*i))
			get_parent().get_parent().tile_set.call_deferred("tile_set_modulate", 7, Color(1,1,1,0.4+0.1*i))
			get_parent().get_parent().tile_set.call_deferred("tile_set_modulate", 12, Color(1,1,1,0.4+0.1*i))
			get_parent().get_parent().tile_set.call_deferred("tile_set_modulate", 13, Color(1,1,1,0.4+0.1*i))
			get_parent().get_parent().tile_set.call_deferred("tile_set_modulate", 16, Color(1,1,1,0.4+0.1*i))
			get_parent().get_parent().tile_set.call_deferred("tile_set_modulate", 19, Color(1,1,1,0.4+0.1*i))
			get_parent().get_parent().tile_set.call_deferred("tile_set_modulate", 20, Color(1,1,1,0.4+0.1*i))
			get_parent().get_parent().get_node('YSort/Foreground').tile_set.call_deferred("tile_set_modulate", 3, Color(1,1,1,0.4+0.1*i))
			yield(get_tree().create_timer(0.05), "timeout")
	else:
		for i in range(7):
			get_parent().get_parent().tile_set.call_deferred("tile_set_modulate", 4, Color(1,1,1,1-0.1*i))
			get_parent().get_parent().tile_set.call_deferred("tile_set_modulate", 7, Color(1,1,1,1-0.1*i))
			get_parent().get_parent().tile_set.call_deferred("tile_set_modulate", 12, Color(1,1,1,1-0.1*i))
			get_parent().get_parent().tile_set.call_deferred("tile_set_modulate", 13, Color(1,1,1,1-0.1*i))
			get_parent().get_parent().tile_set.call_deferred("tile_set_modulate", 16, Color(1,1,1,1-0.1*i))
			get_parent().get_parent().tile_set.call_deferred("tile_set_modulate", 19, Color(1,1,1,1-0.1*i))
			get_parent().get_parent().tile_set.call_deferred("tile_set_modulate", 20, Color(1,1,1,1-0.1*i))
			get_parent().get_parent().get_node('YSort/Foreground').tile_set.call_deferred("tile_set_modulate", 3, Color(1,1,1,1-0.1*i))
			yield(get_tree().create_timer(0.05), "timeout")


func _on_DownWall_body_entered(body):
	self.transparent_count = transparent_count + 1


func _on_DownWall_body_exited(body):
	self.transparent_count = transparent_count - 1
