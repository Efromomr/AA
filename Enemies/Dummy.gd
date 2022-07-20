extends Enemy



func _on_Area2D_area_entered(area):
	$AnimatedSprite.play()


func _on_AnimatedSprite_animation_finished():
	$AnimatedSprite.playing = false
	$AnimatedSprite.frame = 0
	
func set_health(value):
	pass
