extends Control


var big_flame = preload("res://UI/BigFlame.tscn")
var small_flame = preload("res://UI/SmallFlame.tscn")


# Called when the node enters the scene tree for the first time.
func _ready():
	Utils.player.connect("health_changed", self, "draw_health")
	draw_health(Utils.player.health)


func draw_health(value):
	for node in get_children():
		node.queue_free()
	for i in range(value/2):
		var instance = big_flame.instance()
		instance.position.x = 16 + 22 * i
		instance.position.y = 18
		instance.frame = randi()%8
		instance.playing = true
		add_child(instance)
	if value%2 == 1:
		var instance = small_flame.instance()
		instance.position.x = 22 * value/2 
		instance.position.y = 22
		instance.frame = randi()%8
		instance.playing = true
		add_child(instance)
