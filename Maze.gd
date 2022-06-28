extends TileMap

var transparent_area = preload("res://TransparencyArea.tscn")
var room = preload("res://Room.tscn")
var exit = preload("res://Exit.tscn")
var dark_area = preload("res://DarkArea.tscn")
var down_door = preload("res://DownDoor.tscn")
var up_door = preload("res://UpDoor.tscn")
var right_door = preload("res://RightDoor.tscn")
var left_door = preload("res://LeftDoor.tscn")
var grid = []
var new_grid = []
var initial_grid = []
var fixed_rooms = []
var current_fixed_rooms = []
var current_room
func create_room(x1, x2, y1, y2, coords_x, coords_y):
	var mean_x = x1 + (x2-x1)/2
	var mean_y = y1 + (y2-y1)/2
	
	$Foreground.set_cell(x1+1, y1+2, 0)
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
	$Foreground.set_cell(x1, mean_y, 1)
	current_room = grid[coords_x][coords_y]
	$Foreground.set_cell(x2, mean_y, 4)
	$Foreground.set_cell(mean_x-1, y1, 2)
	$Foreground.set_cell(mean_x-1, y2, 3)
	
	set_cell(x1, mean_y, 14)
	set_cell(x2, mean_y, 15)
	
	
	for i in range(x1+1, mean_x-2):
		set_cell(i, y1, 3, false, false, false, Vector2((i-x1)%3, 0)) #upper wall left part
		set_cell(i, y2, 4, false, false, false, Vector2((i-x1)%3, 0)) #down wall left part
	for i in range(mean_x+3, x2):
		set_cell(i, y1, 3, false, false, false, Vector2((i-x1)%3, 0)) #upper wall left part
		set_cell(i, y2, 4, false, false, false, Vector2((i-x1)%3, 0)) #down wall left part
	set_cell(mean_x-2, y1, 17, false, false, false, Vector2((mean_x+1)%3, 0))
	set_cell(mean_x-2, y2, 12, false, false, false, Vector2((mean_x-1)%3, 0))
	set_cell(mean_x-2, y2+1, 16, false, false, false, Vector2((mean_x+2)%3, 0))
	set_cell(mean_x+2, y1, 18, false, false, false, Vector2((mean_x+2)%3, 0))
	set_cell(mean_x+2, y2, 13, false, false, false, Vector2((mean_x+2)%3, 0))
	set_cell(mean_x+2, y2+1, 20, false, false, false, Vector2((mean_x-1)%3, 0))
	set_cell(x1, y2+1, 20, false, false, false, Vector2((mean_x)%3, 0))
	set_cell(x2, y2+1, 16, false, false, false, Vector2((x2+1)%3, 0))
	for i in range(x1+1, x2):
		set_cell(i, y1+6, 0, false, false, false, Vector2(randi()%3,0)) #floor under the wall
		for j in range(y1+7, y2):
			set_cell(i, j, 0, false, false, false, Vector2(randi()%3,1)) #floor
		
	var instance = transparent_area.instance()
	instance.position = map_to_world(Vector2((x1+x2)/2,y2))
	instance.get_node("CollisionShape2D").shape.extents = map_to_world(Vector2((x2-x1+1)/2,0.5))
	current_room.call_deferred("add_child", instance)
	

	if coords_y != 0:
		"""for i in range(9):
			set_cell(mean_x-2, y1-1-i, 23, false, false, false, Vector2(0, i%2))
			set_cell(mean_x-1, y1-1-i, 0, false, false, false, Vector2(randi()%3,1))
			set_cell(mean_x, y1-1-i, 0, false, false, false, Vector2(randi()%3,1))
			set_cell(mean_x+1, y1-1-i, 0, false, false, false, Vector2(randi()%3,1))
			set_cell(mean_x+2, y1-1-i, 24, false, false, false, Vector2(0, i%2))"""
		var tile_instance = up_door.instance()
		tile_instance.position = map_to_world(Vector2(mean_x-1, y1))
		tile_instance.tile = Vector2(mean_x-1, y1)
		current_room.add_child(tile_instance)
	else:
		for i in range(mean_x-3, mean_x+3):
			set_cell(i, y1, 3, false, false, false, Vector2((i-x1)%3, 0))
		$Foreground.set_cell(mean_x-1, y1, -1)
	if coords_y != 7:
		"""for i in range(9):
			set_cell(mean_x-2, y2+6+i, 23, false, false, false, Vector2(0, i%2))
			set_cell(mean_x-1, y2+6+i, 0, false, false, false, Vector2(randi()%3,1))
			set_cell(mean_x, y2+6+i, 0, false, false, false, Vector2(randi()%3,1))
			set_cell(mean_x+1, y2+6+i, 0, false, false, false, Vector2(randi()%3,1))
			set_cell(mean_x+2, y2+6+i, 24, false, false, false, Vector2(0, i%2))"""
		var tile_instance = down_door.instance()
		tile_instance.position = map_to_world(Vector2(mean_x-1, y2))
		tile_instance.tile = Vector2(mean_x-1, y2)
		current_room.add_child(tile_instance)
	else:
		for i in range(mean_x-3, mean_x+3):
			set_cell(i, y2, 4, false, false, false, Vector2((i-x1)%3, 0))
		$Foreground.set_cell(mean_x-1, y2, -1)
	if coords_x != 7:
		"""for i in range(9):
			set_cell(x2+1+i, mean_y-1, 21, false, false, false, Vector2(i%2, 0))
			set_cell(x2+1+i, mean_y+3, 22, false, false, false, Vector2(i%2, 0))"""
		var tile_instance = right_door.instance()
		tile_instance.position = map_to_world(Vector2(x2, mean_y))
		tile_instance.tile = Vector2(x2, mean_y)
		current_room.add_child(tile_instance)
	else:
		for i in range(mean_y-2, mean_y+2):
			set_cell(x2+1+i, mean_y-1, 21, false, false, false, Vector2(i%2, 0))
		$Foreground.set_cell(x2, mean_y, -1)
	if coords_x != 0:
		"""for i in range(8):
			set_cell(x1-i-1, mean_y-1, 21, false, false, false, Vector2(i%2, 0))
			set_cell(x1-i-1, mean_y+3, 22, false, false, false, Vector2(i%2, 0))"""
		var tile_instance = left_door.instance()
		tile_instance.position = map_to_world(Vector2(x1, mean_y))
		tile_instance.tile = Vector2(x1, mean_y)
		current_room.add_child(tile_instance)
	else:
		for i in range(mean_y-1, mean_y+4):
			set_cell(x1, i, 1, false, false, false, Vector2(0, (i-y1-1)%3))
		$Foreground.set_cell(x1, mean_y, -1)
	
			
func step():
	randomize()
	var current_room = grid[Utils.current_room_coords_x][Utils.current_room_coords_y]
	var old_room = grid[Utils.old_room_coords_x][Utils.old_room_coords_y]
	match Utils.player_movement:
		Vector2.UP:
			current_room.x1 = old_room.x1 + old_room.width/2 - current_room.width/2
			current_room.y1 = old_room.y1 - 15 - current_room.height
		Vector2.DOWN:
			current_room.x1 = old_room.x1 + old_room.width/2 - current_room.width/2
			current_room.y1 = old_room.y1 + old_room.height + 15
		Vector2.RIGHT:
			current_room.x1 = old_room.x1 + old_room.width + 9
			current_room.y1 = old_room.y1 + old_room.height/2 - current_room.height/2
		Vector2.LEFT:
			current_room.x1 = old_room.x1 - current_room.width - 9
			current_room.y1 = old_room.y1 + old_room.height/2 - current_room.height/2
	var instance = dark_area.instance()
	instance.position = map_to_world(Vector2(current_room.x1, current_room.y1))
	instance.get_node("Sprite").position = Vector2(16*(current_room.width+1), 12*(current_room.height+1))
	instance.get_node("Sprite").scale = Vector2(16*(current_room.width+1), (12*current_room.height+1))
	current_room.add_child(instance)
	create_room(current_room.x1, current_room.x1 + current_room.width, current_room.y1, current_room.y1 + current_room.height, Utils.current_room_coords_x, Utils.current_room_coords_y)
	current_room.built = true
	for room_ in get_tree().get_nodes_in_group('rooms'):
		if Vector2(room_.coords_x, room_.coords_y) in current_fixed_rooms and not room_.built:
			var x1; var y1
			match Vector2(room_.coords_x, room_.coords_y) - Vector2(current_room.coords_x, current_room.coords_y):
				Vector2.UP:
					x1 = current_room.x1 + current_room.width/2 - room_.width/2
					y1 = current_room.y1 - 15 - room_.height
				Vector2.DOWN:
					x1 = current_room.x1 + current_room.width/2 - room_.width/2
					y1 = current_room.y1 +current_room.height + 15
				Vector2.RIGHT:
					x1 = current_room.x1 + current_room.width + 9
					y1 = current_room.y1 + current_room.height/2 - room_.height/2
				Vector2.LEFT:
					x1 = current_room.x1 - room_.width - 9
					y1 = current_room.y1 + current_room.height/2 - room_.height/2
			
			create_room(x1, x1 + room_.width, y1, y1+room_.height, room_.coords_x, room_.coords_y)
			room_.built = true
		if not Vector2(room_.coords_x, room_.coords_y) in current_fixed_rooms and room_.built:
			
			
			room_.enable_dark()
	current_room.open_doors()
	current_room.spawn_exits()
	
	
func _ready():
	for x in range(8):
		grid.append([])
		grid[x]=[]
		initial_grid.append([])
		initial_grid[x]=[]
		for y in range(8):
			var room_instance = room.instance()
			grid[x].append([])
			grid[x][y]=room_instance
			grid[x][y].coords_x = x
			grid[x][y].coords_y = y
			add_child(room_instance)
			initial_grid[x].append([])
			initial_grid[x][y]=0
	var initial_room = grid[0][0]
	create_room(grid[0][0].x1, grid[0][0].x1+grid[0][0].width, grid[0][0].y1, grid[0][0].y1+grid[0][0].height, grid[0][0].coords_x, grid[0][0].coords_y)
	#create_room(grid[0][0].x1, grid[0][0].x1+grid[0][0].width, grid[0][0].y1 + grid[0][0].height + 15, grid[0][0].y1 + grid[0][0].height + 15 + grid[0][1].height, grid[0][1].coords_x, grid[0][1].coords_y)
	#create_room(grid[0][0].x1 + grid[0][0].width+9, grid[0][0].x1 + grid[0][0].width+9+grid[1][0].width, grid[0][0].y1, grid[0][0].y1+grid[0][0].height, grid[1][0].coords_x, grid[1][0].coords_y)
	grid[0][0].built = true
	#grid[0][1].built = true
	#grid[1][0].built = true
	grid[0][0].spawn_exits()
	update_bitmask_region()
	$Foreground.place_tile_scenes()
	"""var instance = dark_area.instance()
	instance.position = map_to_world(Vector2(grid[0][0].x1, grid[0][0].y1))
	instance.get_node("Sprite").position = Vector2(16*(initial_room.width+1), 12*(initial_room.height+1))
	instance.get_node("Sprite").scale = Vector2(16*(initial_room.width+1), (12*initial_room.height+1))
	grid[0][0].add_child(instance)"""
	$Foreground.set_cell(grid[0][0].x1+grid[0][0].width/2-1, grid[0][0].y1+grid[0][0].height, -1)
	
func get_fixed_rooms():
	current_fixed_rooms = fixed_rooms.duplicate()
	current_fixed_rooms.append(Vector2(Utils.current_room_coords_x, Utils.current_room_coords_y))
	if Utils.current_room_coords_x!=0:
		current_fixed_rooms.append(Vector2(Utils.current_room_coords_x-1, Utils.current_room_coords_y))
	if Utils.current_room_coords_x!=7:
		current_fixed_rooms.append(Vector2(Utils.current_room_coords_x+1, Utils.current_room_coords_y))
	if Utils.current_room_coords_y!=0:
		current_fixed_rooms.append(Vector2(Utils.current_room_coords_x, Utils.current_room_coords_y-1))
	if Utils.current_room_coords_y!=7:
		current_fixed_rooms.append(Vector2(Utils.current_room_coords_x, Utils.current_room_coords_y+1))
	mix_rooms() 
func mix_rooms():
	"""new_grid = initial_grid.duplicate(true)
	for k in range(current_fixed_rooms.size()):
		new_grid[int(current_fixed_rooms[k].x)][int(current_fixed_rooms[k].y)] = grid[int(current_fixed_rooms[k].x)][int(current_fixed_rooms[k].y)]
	var dir = Utils.random_choice([Vector2.DOWN, Vector2.UP, Vector2.RIGHT, Vector2.LEFT])
	match dir:
		Vector2.DOWN:
			for x in range(8):
				var y_array = []
				for y in range (8):
					if !(Vector2(x,y) in current_fixed_rooms):
						y_array.append(y)
				var y_array_sorted = y_array.duplicate()
				var new_elem = y_array_sorted.pop_back()
				y_array_sorted.push_front(new_elem)
				for y in (y_array.size()):
					new_grid[x][y_array[y]] = grid[x][y_array_sorted[y]]
		Vector2.UP:
			for x in range(8):
				var y_array = []
				for y in range (8):
					if !(Vector2(x,y) in current_fixed_rooms):
						y_array.append(y)
				var y_array_sorted = y_array.duplicate()
				var new_elem = y_array_sorted.pop_front()
				y_array_sorted.push_back(new_elem)
				for y in (y_array.size()):
					new_grid[x][y_array[y]] = grid[x][y_array_sorted[y]]
		Vector2.RIGHT:
			for y in range(8):
				var x_array = []
				for x in range (8):
					if !(Vector2(x,y) in current_fixed_rooms):
						x_array.append(x)
				var x_array_sorted = x_array.duplicate()
				var new_elem = x_array_sorted.pop_back()
				x_array_sorted.push_front(new_elem)
				for x in (x_array.size()):
					new_grid[x_array[x]][y] = grid[x_array_sorted[x]][y]
		Vector2.LEFT:
			for y in range(8):
				var x_array = []
				for x in range (8):
					if !(Vector2(x,y) in current_fixed_rooms):
						x_array.append(x)
				var x_array_sorted = x_array.duplicate()
				var new_elem = x_array_sorted.pop_front()
				x_array_sorted.push_back(new_elem)
				for x in (x_array.size()):
					new_grid[x_array[x]][y] = grid[x_array_sorted[x]][y]
	grid = new_grid.duplicate(true)
	for x in range(8):
		for y in range(8):
			new_grid[x][y].coords_x = x
			new_grid[x][y].coords_y = y"""
	step()
