extends TileMap


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	for i in range(100):
		for j in range(100):
			set_cell(i, j, 0, false, false, false, Vector2(1,1))
