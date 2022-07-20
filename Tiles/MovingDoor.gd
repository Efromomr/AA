extends Node2D
var tile
var tile_id
var opened = false
onready var tween = $Tween

func _ready():
	tile_id = get_tree().get_root().get_node("Maze/YSort/Foreground").get_cellv(tile)
	if tile_id in [11, 12]:
		$Sprite.region_rect = Rect2(133,72,50,71)
	elif tile_id == 13:
		$Sprite.region_rect = Rect2(21,0,14,94)
	elif tile_id == 14:
		$Sprite.region_rect = Rect2(35,0,14,95)
func open():
	opened = true
	$Sprite.visible = true
	get_tree().get_root().get_node("Maze/YSort/Foreground").set_cellv(tile, -1)
	tween.interpolate_property(self, "position",
		position, position+Vector2(0, -100), 1,
		Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween.interpolate_property($Sprite, "modulate",
		 Color(1, 1, 1, 1), Color(1, 1, 1, 0), 1, 
	  Tween.TRANS_LINEAR, Tween.EASE_IN)
	tween.start()
func close():
	opened = false
	visible = true
	tween.interpolate_property(self, "position",
		position, position-Vector2(0, -100), 1,
		Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween.interpolate_property($Sprite, "modulate",
		 Color(1, 1, 1, 0), Color(1, 1, 1, 1), 1, 
	  Tween.TRANS_LINEAR, Tween.EASE_IN)
	tween.start()
	



func _on_Tween_tween_completed(object, key):
	if not opened:
		visible = false
		get_tree().get_root().get_node("Maze/YSort/Foreground").set_cellv(tile, tile_id)
