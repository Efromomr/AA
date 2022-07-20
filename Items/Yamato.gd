extends Weapon

var detecting_area = preload("res://Projectiles/DetectingArea.tscn")
var slices_pro = preload("res://Projectiles/JudgementCutPro.tscn")
var ready = false
var list_of_enemies = []


func shoot(a, b, c=true):
	$Sprite.frame = 1
	ready = true
func move_weapon():
	hand.position = Vector2(-3,5)
	set_physics_process(false)
	
func _input(event):
	if Input.is_action_just_released("attack") and ready:
		var instance = detecting_area.instance()
		instance.position = position
		add_child(instance)
		yield(instance, "tree_exited")
		$Sprite.frame = 0
		ready = false
		for enemy in list_of_enemies:
			var proj_ins = slices_pro.instance()
			proj_ins.position = enemy.global_position
			proj_ins.get_node("AnimatedSprite").play()
			proj_ins.enemy = enemy.get_parent()
			#enemy.health -= 20
			get_tree().get_root().add_child(proj_ins)
		list_of_enemies = []
			
