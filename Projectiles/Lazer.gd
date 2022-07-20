extends Node2D


var is_casting = false setget set_casting
var cast_point
func _ready():
	set_physics_process(false)
	visible = false
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if not $RayCast2D.is_colliding():
		cast_point = $RayCast2D.cast_to
	$RayCast2D.force_raycast_update()
	if $RayCast2D.is_colliding():
		cast_point =$RayCast2D.get_collision_point()
		if $RayCast2D.get_collider().get_parent().get_class() == "Enemy":
			$RayCast2D.get_collider().get_parent().health -= delta * 100
	#rotation_degrees = rad2deg(get_local_mouse_position().angle())
	$Ray2/End.global_position = cast_point
	$Ray2/Sprite.set_region_rect(Rect2(0, 0, $Ray2/End.position.x - $Ray2/Start.position.x, 5))
	$Ray2/Sprite.position.x = ($Ray2/End.position.x - $Ray2/Start.position.x)/2
	$Ray2/Particles2D.process_material.emission_box_extents.x = ($Ray2/End.position.x - $Ray2/Start.position.x)/2
	$Ray2/Particles2D.position.x = ($Ray2/End.position.x - $Ray2/Start.position.x)/2
	$Ray2/Particles2D2.position.x = $Ray2/End.position.x + 4
	$Ray/End.global_position = cast_point
	$Ray/Sprite.set_region_rect(Rect2(0, 0, $Ray/End.position.x - $Ray/Start.position.x, 5))
	$Ray/Sprite.position.x = ($Ray/End.position.x - $Ray/Start.position.x)/2
	$Ray/Particles2D.process_material.emission_box_extents.x = ($Ray/End.position.x - $Ray/Start.position.x)/2
	$Ray/Particles2D.position.x = ($Ray/End.position.x - $Ray/Start.position.x)/2
	$Ray/Particles2D2.position.x = $Ray/End.position.x + 4
	$RayCast2D.look_at(get_global_mouse_position())
	$Ray.position.x = cos(get_local_mouse_position().angle()) - 4
	$Ray.position.y = sin(get_local_mouse_position().angle())
	$Ray/End.position.y = $Ray/Sprite.position.y
	$Ray.rotation = get_local_mouse_position().angle()
	$Ray2.position.x = cos(get_local_mouse_position().angle())
	$Ray2.position.y = sin(get_local_mouse_position().angle())
	$Ray2.rotation = get_local_mouse_position().angle()
	#look_at(get_global_mouse_position())
func _input(event):
	if Input.is_action_just_pressed("space"):
		if is_casting:
			self.is_casting = false
			Utils.player.can_attack = true
		elif Utils.player.can_attack:
			self.is_casting = true
			Utils.player.can_attack = false
		
func appear():
	visible = true
	$Ray/Particles2D.visible = true
	$Ray/Particles2D2.visible = true
	$Ray2/Particles2D.visible = true
	$Ray2/Particles2D2.visible = true
	#$Tween.stop_all()
	$Tween.interpolate_property($Ray, "scale:y", 0, 1, 0.5, Tween.TRANS_LINEAR, Tween.EASE_IN)
	$Tween.interpolate_property($Ray2, "scale:y", 0, 1, 0.5, Tween.TRANS_LINEAR, Tween.EASE_IN)
	#$Tween.interpolate_property($Sprite, "scale:y", 0, 1, 0.5, Tween.TRANS_LINEAR, Tween.EASE_IN)
	#$Tween.interpolate_property($End, "scale:y", 0, 1, 0.5, Tween.TRANS_LINEAR, Tween.EASE_IN)
	$Tween.start()
func disappear():
	$Ray/Particles2D.visible = false
	$Ray/Particles2D2.visible = false
	$Ray2/Particles2D.visible = false
	$Ray2/Particles2D2.visible = false
	#$Tween.stop_all()
	$Tween.interpolate_property($Ray, "scale:y", 1, 0, 0.5, Tween.TRANS_LINEAR, Tween.EASE_IN)
	$Tween.interpolate_property($Ray2, "scale:y", 1, 0, 0.5, Tween.TRANS_LINEAR, Tween.EASE_IN)
	#$Tween.interpolate_property($Sprite, "scale:y", 1, 0, 0.5, Tween.TRANS_LINEAR, Tween.EASE_IN)
	#$Tween.interpolate_property($End, "scale:y", 1, 0, 0.5, Tween.TRANS_LINEAR, Tween.EASE_IN)
	$Tween.start()
func set_casting(cast):
	is_casting = cast
	if is_casting:
		appear()
	else:
		disappear()
	set_physics_process(is_casting)

