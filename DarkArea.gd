extends Node2D


func disable():
	$Tween.interpolate_property($Sprite, "modulate",
		 Color(1, 1, 1, 1), Color(1, 1, 1, 0), 2, 
	  Tween.TRANS_LINEAR, Tween.EASE_IN)
	$Tween.start()
func enable():
	$Tween.interpolate_property($Sprite, "modulate",
		 Color(1, 1, 1, 0), Color(1, 1, 1, 1), 2, 
	  Tween.TRANS_LINEAR, Tween.EASE_IN)
	$Tween.start()
