extends Control


var charcoal_1 = preload("res://UI/Charcoal1.tscn")
var charcoal_2 = preload("res://UI/Charcoal2.tscn")
var charcoal_3 = preload("res://UI/CharcoalExtinct.tscn")
var charcoal_4 = preload("res://UI/Charcoal4.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	
	Utils.player.connect("health_changed", self, "draw_health")
	draw_health(Utils.player.health)



func draw_health(value):
	
	var total_count = Utils.player.max_health/3 + clamp(Utils.player.max_health%3, 0, 1)
	var non_empty_count = value/3 + clamp(value%3, 0, 1)
	for node in $Charcoals.get_children():
		node.queue_free() 
	for i in range(value/3):
		var instance = charcoal_1.instance()
		instance.position.x = 100 + 34 * i
		instance.position.y = 35
		instance.frame = randi()%19
		instance.playing = true
		$Charcoals.add_child(instance)
	if value%3 == 2:
		var instance = charcoal_2.instance()
		instance.position.x = 100 + 34 * (value/3) - 3
		instance.position.y = 43
		instance.frame = randi()%19
		instance.playing = true
		$Charcoals.add_child(instance)
	if value%3 == 1:
		var instance = charcoal_3.instance()
		instance.position.x = 100 + 34 * (value/3) - 2
		instance.position.y = 49
		instance.frame = randi()%33
		instance.playing = true
		$Charcoals.add_child(instance)
	for i in range (non_empty_count, total_count):
		var instance = charcoal_4.instance()
		instance.position.x = 100 + 34 * (i) - 2
		instance.position.y = 55
		$Charcoals.add_child(instance)

	
func _input(event):
	if Input.is_action_just_pressed('book'):
		if $Book.visible:
			$Book.visible = false
			$AnimationPlayer.play("RESET")
			get_tree().paused = false
			$TextureRect.modulate = Color(1, 1, 1, 1)
			$Charcoals.modulate = Color(1, 1, 1, 1)
			$Tween.stop_all()
		else:
			$Book.visible = true
			$AnimationPlayer.play("play")
			get_tree().paused = true
			$Tween.interpolate_property($Charcoals, "modulate",
			Color(1, 1, 1, 1), Color(1, 1, 1, 0), 2, 
			Tween.TRANS_LINEAR, Tween.EASE_IN)
			$Tween.interpolate_property($TextureRect, "modulate",
			Color(1, 1, 1, 1), Color(1, 1, 1, 0), 2, 
			Tween.TRANS_LINEAR, Tween.EASE_IN)
			$Tween.interpolate_property($Sprite, "modulate",
			Color(1, 1, 1, 1), Color(1, 1, 1, 0), 2, 
			Tween.TRANS_LINEAR, Tween.EASE_IN)
			$Tween.interpolate_property($Path2D, "modulate",
			Color(1, 1, 1, 1), Color(1, 1, 1, 0), 2, 
			Tween.TRANS_LINEAR, Tween.EASE_IN)
			$Tween.start()
	if Input.is_action_just_pressed('tab') and $Path2D.visible:
		for node in $Path2D.get_children():
			if node.offset == 200:
				$PathT.interpolate_property(node, "offset",
				node.offset, 264.29, 1, 
				Tween.TRANS_LINEAR, Tween.EASE_IN)
				$PathT.interpolate_property(node, "scale",
				Vector2(1,1), Vector2(0.7,0.7), 1, 
				Tween.TRANS_LINEAR, Tween.EASE_IN)
				$PathT.interpolate_property(node, "modulate",
				Color(1, 1, 1, 1), Color(1, 1, 1, 0.6), 1, 
				Tween.TRANS_LINEAR, Tween.EASE_IN)
			elif int(round(node.offset)) == 30:
				$PathT.interpolate_property(node, "offset",
				node.offset, 100, 1, 
				Tween.TRANS_LINEAR, Tween.EASE_IN)
				$PathT.interpolate_property(node, "scale",
				Vector2(0.7,0.7), Vector2(0.8,0.8), 1, 
				Tween.TRANS_LINEAR, Tween.EASE_IN)
				$PathT.interpolate_property(node, "modulate",
				Color(1, 1, 1, 0.6), Color(1, 1, 1, 0.7), 1, 
				Tween.TRANS_LINEAR, Tween.EASE_IN)
			elif node.offset == 100:
				$PathT.interpolate_property(node, "offset",
				node.offset, 200, 1, 
				Tween.TRANS_LINEAR, Tween.EASE_IN)
				$PathT.interpolate_property(node, "scale",
				Vector2(0.8, 0.8), Vector2(1,1), 1, 
				Tween.TRANS_LINEAR, Tween.EASE_IN)
				$PathT.interpolate_property(node, "modulate",
				Color(1, 1, 1, 0.7), Color(1, 1, 1, 1), 1, 
				Tween.TRANS_LINEAR, Tween.EASE_IN)
			$PathT.start()
			
			
			
			
			
			
			
			
			
			
			
