extends Node2D
var tile
onready var tween = $Tween

func open():
	$Sprite.visible = true
	get_tree().get_root().get_node("Maze/Foreground").set_cellv(tile, -1)
	tween.interpolate_property(self, "position",
		position, position+Vector2(0, -100), 1,
		Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween.interpolate_property($Sprite, "modulate",
		 Color(1, 1, 1, 1), Color(1, 1, 1, 0), 1, 
	  Tween.TRANS_LINEAR, Tween.EASE_IN)
	tween.start()
func close():
	tween.interpolate_property(self, "position",
		position, position-Vector2(0, -100), 1,
		Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween.interpolate_property($Sprite, "modulate",
		 Color(1, 1, 1, 0), Color(1, 1, 1, 1), 1, 
	  Tween.TRANS_LINEAR, Tween.EASE_IN)
	tween.start()
	

