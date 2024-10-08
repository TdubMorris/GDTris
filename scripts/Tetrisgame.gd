extends TileMap

func _ready():
	
	new_game()
	pass 


# Tetrominos!
var bag = data.Tetros.values().duplicate()

#Picking Colors
var colors = [
	Vector2i(4,0),
	Vector2i(5,0),
	Vector2i(1,0),
	Vector2i(2,0),
	Vector2i(3,0),
	Vector2i(6,0),
	Vector2i(0,0),
]


# Game variables
var tetro
var rot_index : int = 0
var active_tetro : Array

#Movement Variables
var steps : float
var speed : float = 1.0
const start_pos = Vector2i(6,-2)
var cur_pos : Vector2i

var left_delay : float = 0.0
var left_speed : float = 0.0
var right_delay : float = 0.0
var right_speed : float = 0.0

#Tilemap
var tile_id : int = 0
var color_atlas : Vector2i
var next_color_atlas : Vector2i

var rows := 20
var cols := 10
var top := -2

#Layers
const board_layer : int = 0
const active_layer : int = 1
const preview_layer = 2


#On starting a new game
func new_game():
	print(data.Tetros.I)
	speed = 1.5
	steps = 0.0
	tetro = pick_tetro();
	create_tetro()

func create_tetro():
	steps = 0.0
	cur_pos = start_pos
	rot_index = 0
	active_tetro = tetro[rot_index]
	draw_tetro(active_tetro, cur_pos, color_atlas)

# Select a piece
func pick_tetro():
	var selection
	if not bag.is_empty():
		bag.shuffle()
		selection = bag.pop_front()
	else:
		bag = data.Tetros.values().duplicate()
		bag.shuffle()
		selection = bag.pop_front()
	color_atlas = colors[selection]
	return data.Cells[selection]


func draw_tetro(piece, pos : Vector2i, atlas : Vector2i):
	for i in piece:
		set_cell(active_layer, pos + i, tile_id, atlas)
	pass


func move_tetro(dir):
	if can_move(dir, cur_pos):
		#clear prev tetro
		for i in active_tetro:
			erase_cell(active_layer, cur_pos + i)
		cur_pos += dir
		draw_tetro(active_tetro, cur_pos, color_atlas)
		
		
	elif dir == Vector2i.DOWN:     #land pieces
		land_piece()


func rotate_tetro():
	for i in active_tetro:
		erase_cell(active_layer, cur_pos + i)
	
	rotation_check((rot_index + 1) % 4)
	
	for i in active_tetro:
		draw_tetro(active_tetro, cur_pos, color_atlas)


func rotation_check(new_rot):
	var tests = data.cw_test
	if tetro == data.Cells[data.Tetros.I]:
		tests = data.cw_test_I
	
	for test_pos in tests[new_rot]:
		
		var passed = true
		
		for tile_pos in tetro[new_rot]:
			if not get_cell_source_id(board_layer, tile_pos + cur_pos + test_pos) == -1:
				passed = false
				break
		
		if passed == true:
			rot_index = new_rot
			cur_pos += test_pos
			active_tetro = tetro[new_rot]
			return
	
	#fail all tests
	return
	

func can_move(dir, pos):
	var cm = true
	for i in active_tetro:
		if not get_cell_source_id(board_layer, i + dir + pos) == -1:
			cm = false
	return cm

func land_piece():
	for i in active_tetro:
		erase_cell(active_layer, cur_pos + i)
		set_cell(board_layer, cur_pos + i, tile_id, color_atlas)
	row_check()
	
	tetro = pick_tetro()
	create_tetro()


func row_check():
	var count = 0
	for y in range(top, rows+1):
		for x in range(1,cols+1):
			if not get_cell_source_id(board_layer, Vector2i(x,y)) == -1:
				count += 1
		if count == cols:
			clear_row(y)
		count = 0

func clear_row(row):
	var atlas
	for y in range(row, top+1, -1):
		for x in range(1, cols+1):
			if not get_cell_source_id(board_layer, Vector2i(x,y-1)) == -1:
				atlas = get_cell_atlas_coords(board_layer, Vector2i(x,y-1))
				set_cell(board_layer, Vector2i(x,y), tile_id, atlas)
			else: erase_cell(board_layer, Vector2i(x,y))

func hard_drop():
	var new_pos = cur_pos
	while can_move(Vector2i.DOWN, new_pos):
		new_pos += Vector2i.DOWN
	return new_pos

func draw_preview():
	clear_layer(preview_layer)
	var preview_pos = hard_drop()
	for p in active_tetro:
		set_cell(preview_layer, preview_pos + p, tile_id, color_atlas)



func _process(delta):
	
	#keyboard controls ================================================================================
	if Input.is_action_just_pressed("up"):
		rotate_tetro()
	
	if Input.is_action_just_pressed("left"):
		left_delay = 0.0
		left_speed = 0.0
		move_tetro(Vector2i.LEFT)
	if Input.is_action_just_pressed("right"):
		right_delay = 0.0
		right_speed = 0.0
		move_tetro(Vector2i.RIGHT)
	if Input.is_action_just_pressed("down"):
		steps = 0.0
		move_tetro(Vector2i.DOWN)
	
	if Input.is_action_pressed("left"):
		left_delay += delta
		left_speed += delta
		if left_delay >= data.DAS / 60:
			if left_speed >= data.ARR / 60:
				left_speed = 0.0
				move_tetro(Vector2i.LEFT)
	
	if Input.is_action_pressed("right"):
		right_delay += delta
		right_speed += delta
		if right_delay >= data.DAS / 60:
			if right_speed >= data.ARR / 60:
				right_speed = 0.0
				move_tetro(Vector2i.RIGHT)
	
	if Input.is_action_pressed("left") or Input.is_action_pressed("right"):
		if not can_move(Vector2i.DOWN, cur_pos):
			steps -= 0.5 * speed * delta
	
	
	if Input.is_action_pressed("down"):
		steps += speed * (data.SDF-1) * delta
	
	if Input.is_action_just_pressed("space"):
		for i in active_tetro:
			erase_cell(active_layer, cur_pos+i)
		
		cur_pos = hard_drop()
		land_piece()
	#========================================================================================
	
	draw_preview()
	
	steps += speed * delta
	
	if steps > 1:
		move_tetro(Vector2i.DOWN)
		steps = 0
	
	pass
