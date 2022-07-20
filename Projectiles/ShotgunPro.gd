extends Projectile


var dust = load("res://DustsTextures/ShotgunDust.tscn")


# Called when the node enters the scene tree for the first time.
func _ready():
	var instance = dust.instance()
	instance.emitting = true
	instance.position = position 
	instance.rotation = rotation
	get_tree().get_root().add_child(instance)
	yield(get_tree().create_timer(0.2), "timeout")
	queue_free()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
