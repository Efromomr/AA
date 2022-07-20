extends Node2D


var counter = 0


# Called when the node enters the scene tree for the first time.
func _ready():
	get_parent().get_node('Maze').connect('step', self, 'counter')


func counter():
	counter+=1
	if counter == 2:
			queue_free()
