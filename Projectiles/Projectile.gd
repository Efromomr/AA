extends RigidBody2D

class_name Projectile

var damage = 0
var friendly setget set_friendly

func _ready():
	contacts_reported = true
	contact_monitor = 1
	self.connect("body_shape_entered", self, '_on_RigidBody2D_body_shape_entered')
	$Area2D.set_collision_layer_bit(5, 32)
	$Area2D.set_collision_layer_bit(6, 64)
	set_collision_mask_bit(0,1)
	
func _on_RigidBody2D_body_shape_entered(body_rid, body, body_shape_index, local_shape_index):
	#var dust_instance = dust.instance()
	#get_tree().get_root().call_deferred("add_child", dust_instance)
	#dust_instance.position = position
	#dust_instance.emitting = true
	#instance.position = position
	#instance.rotation = rotation
	queue_free()
	
func set_friendly(value):
	friendly = value
	if friendly:
		$Area2D.set_collision_layer_bit(2, 4)
	else:
		$Area2D.set_collision_layer_bit(4, 16)
	
