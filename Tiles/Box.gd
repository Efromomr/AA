extends Node2D

var player_near = false
var tile
var tile_id
	
func _ready():
	tile_id = get_tree().get_root().get_node("Maze/YSort/Foreground").get_cellv(tile)
func _input(event):
	if Input.is_action_pressed("interact") and player_near:
		if tile_id == 9:
			get_parent().foreground.set_cellv(tile, 10)


func _on_Area2D_body_entered(body):
	player_near = true


func _on_Area2D_body_exited(body):
	player_near = false
