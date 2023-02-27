extends TileMap

var dark_area = preload('res://DarkArea.tscn')

var x1 = 0
var width = 15
var height = 15
var y1 = 0


func _ready():
	create_room(x1, x1 + width, y1, y1+height, 0, 0)

func create_room(x1, x2, y1, y2, coords_x, coords_y):
	
	var mean_x = x1 + (x2-x1)/2
	var mean_y = y1 + (y2-y1)/2
	
	#corners
	set_cell(x1, y1, 5)
	set_cell(x2, y1, 6)
	set_cell(x1, y2, 7)
	set_cell(x2, y2, 19)
	for i in range(y1+1, mean_y-1):
		set_cell(x1, i, 1, false, false, false, Vector2(0, (i-y1-1)%3)) #left wall upper part
		set_cell(x2, i, 2, false, false, false, Vector2(0, (i-y1-1)%3)) #right wall upper part
	for i in range (mean_y+4, y2):
		set_cell(x1, i, 1, false, false, false, Vector2(0, (i-y1-1)%3)) #left wall down part
		set_cell(x2, i, 2, false, false, false, Vector2(0, (i-y1-1)%3)) #right wall down part
	set_cell(x1, mean_y-1, 8, false, false, false, Vector2(0,abs(mean_y%3))) #upper border tile left wall
	set_cell(x2, mean_y-1, 9, false, false, false, Vector2(0,abs(mean_y%3))) #upper border tile right wall
	set_cell(x1, mean_y+3, 10, false, false, false, Vector2(0,abs(mean_y%3))) #upper border tile left wall
	set_cell(x2, mean_y+3, 11, false, false, false, Vector2(0,abs(mean_y%3))) #upper border tile right wall

	
	set_cell(x1, mean_y, 14)
	set_cell(x2, mean_y, 15)
	
	
	for i in range(x1+1, mean_x-2):
		set_cell(i, y1, 3, false, false, false, Vector2((i-x1)%3, 0)) #upper wall left part
		set_cell(i, y2, 4, false, false, false, Vector2((i-x1)%3, 0)) #down wall left part
	for i in range(mean_x+3, x2):
		set_cell(i, y1, 3, false, false, false, Vector2((i-x1)%3, 0)) #upper wall left part
		set_cell(i, y2, 4, false, false, false, Vector2((i-x1)%3, 0)) #down wall left part
	set_cell(mean_x-2, y1, 17, false, false, false, Vector2((mean_x-2)%3, 0))
	set_cell(mean_x-2, y2, 12, false, false, false, Vector2((mean_x-2)%3, 0))
	set_cell(mean_x-2, y2+1, 16, false, false, false, Vector2((mean_x+2)%3, 0))
	set_cell(mean_x+2, y1, 18, false, false, false, Vector2((mean_x+2)%3, 0))
	set_cell(mean_x+2, y2, 13, false, false, false, Vector2((mean_x+2)%3, 0))
	set_cell(mean_x+2, y2+1, 20, false, false, false, Vector2((mean_x+2)%3, 0))
	set_cell(x1, y2+1, 20, false, false, false, Vector2((mean_x)%3, 0))
	set_cell(x2, y2+1, 16, false, false, false, Vector2((x2+1)%3, 0))
	for i in range(x1+1, x2):
		set_cell(i, y1+6, 0, false, false, false, Vector2(randi()%3,0)) #floor under the wall
		for j in range(y1+7, y2):
			set_cell(i, j, 0, false, false, false, Vector2(randi()%3,1)) #floor
		
	#var instance = transparent_area.instance()
	#instance.position = map_to_world(Vector2((x1+x2)/2,y2))
	#instance.get_node("CollisionShape2D").shape.extents = map_to_world(Vector2((x2-x1+1)/2,0.5))
	#current_room.call_deferred("add_child", instance)
	
	


	#current_room.spawn_individual_tiles()
	#current_room.spawn_enemies()
	
	
func spawn_individual_tiles():
	var instance = dark_area.instance()
	instance.position = get_parent().map_to_world(Vector2(x1, y1))
	instance.get_node("Sprite").position = Vector2(16*(width+1), 12*(height+1))
	instance.get_node("Sprite").scale = Vector2(16*(width+1), (12*height+1))
	add_child(instance)
	instance.enable()
	.spawn_individual_tiles()
