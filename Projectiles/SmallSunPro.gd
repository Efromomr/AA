extends RigidBody2D

var small_sun = preload("res://Projectiles/SunshineBowArrow.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	var death_timer = Timer.new()
	death_timer.set_one_shot(false)
	death_timer.set_wait_time(2)
	death_timer.connect("timeout", self, "explode")
	add_child(death_timer)
	death_timer.start()


func _on_Area2D_area_entered(area):
	queue_free()
	
func explode():
	var count = 15
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
		node.linear_velocity = direction * 200
		node.rotation = direction.angle()
		node.rotation_degrees -= 90
		node.friendly = false
		node.damage = 0
		get_tree().get_root().add_child(node)
		angle+= angle_step
	queue_free()
	
