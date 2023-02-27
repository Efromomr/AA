extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Area2D_area_entered(area):
	pass
	if not area.get_parent().friendly:
		area.get_parent().friendly = true
		area.get_parent().linear_velocity *=-1
		area.get_parent().get_node("Sprite").rotation_degrees += 180
