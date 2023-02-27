extends Node2D

var small_sun = preload("res://Projectiles/SmallSunPro.tscn")
func _ready():
	$Tween.interpolate_property(self, "position",
	position, position+Vector2(0, -100), 1,
	Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$Tween.start()
	
	
func explode():
	var count = 10
	var radius = 100
	var center = position

# Get how much of an angle objects will be spaced around the circle.
# Angles are in radians so 2.0*PI = 360 degrees
	var angle_step = 2.0*PI / count

	var angle = 0
# For each node to spawn
	for i in range(0, count):
		
		var direction = Vector2(cos(angle), sin(angle))
		var pos = center + direction * radius
		var node = small_sun.instance()
		node.position = pos
		get_tree().get_root().add_child(node)
		angle+= angle_step
	queue_free()
func _on_Tween_tween_completed(object, key):
	explode()
	visible = false
	
	
	
