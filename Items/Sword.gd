extends Weapon


func _init():
	radius = 8
	offset_x = -5
	offset_y = 5
	rot_offset = 45
	damage = 10
func shoot(pos, dir, friendly=true):
	$Area2D/CollisionShape2D.disabled = false
	$Area2D2/CollisionShape2D.disabled = false
	#$Tween.interpolate_property(self, "position",
		#position, position-Vector2(0, -100), 1,
		#Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$Tween.interpolate_property(self, "rotation_degrees",
		 rotation_degrees-50, rotation_degrees+30, 0.1, 
	  Tween.TRANS_QUAD, Tween.EASE_IN)
	$Tween.interpolate_property(self, "position:x",
		 position.x + cos(deg2rad(-50))*15, position.x + cos(deg2rad(30))*15, 0.1, 
	  Tween.TRANS_QUAD, Tween.EASE_IN)
	$Tween.interpolate_property(self, "position:y",
		 position.y + sin(deg2rad(-50))*15, position.y + sin(deg2rad(30))*15, 0.1, 
	  Tween.TRANS_QUAD, Tween.EASE_IN)
	$Tween.interpolate_property(hand, "position:x",
		 position.x + cos(deg2rad(-50))*5, position.x + cos(deg2rad(30))*5, 0.1, 
	  Tween.TRANS_QUAD, Tween.EASE_IN)
	$Tween.interpolate_property(hand, "position:y",
		 position.y + sin(deg2rad(-50))*5, position.y + sin(deg2rad(30))*5, 0.1, 
	  Tween.TRANS_QUAD, Tween.EASE_IN)
	$Tween.start()


func _on_Tween_tween_completed(object, key):
	$Area2D/CollisionShape2D.disabled = true
	$Area2D2/CollisionShape2D.disabled = true


func _on_Area2D_area_entered(area):
	if not area.get_parent().friendly:
		area.get_parent().queue_free()
