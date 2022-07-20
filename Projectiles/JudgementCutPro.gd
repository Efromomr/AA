extends Node2D
var enemy
onready var tween = $Tween

func _on_AnimatedSprite_animation_finished():
	tween.interpolate_property($AnimatedSprite, "modulate",
		 Color(1, 1, 2, 1), Color(1, 1, 2, 0), 1, 
	  Tween.TRANS_LINEAR, Tween.EASE_IN)
	tween.start()
	enemy.health -=20


func _on_Tween_tween_completed(object, key):
	queue_free()
