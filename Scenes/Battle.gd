extends Node2D

signal scene_finished
signal scene_failed

var active : bool = false

var character = null setget new_character
var movement_queue = []
var character_original_position : Vector2 = Vector2.ZERO
var character_movement_range = 5



func new_character(chara):
	
	# don't allow non-character characters
	if not chara.is_in_group("OnMap"):
		return
	
	# clear the movement queue upon a change in character
	movement_queue = []
	
	# set the character's map postiton
	chara.map_position = $TileMap.world_to_map(chara.position)
	chara.target_position = $TileMap.map_to_world(chara.map_position)
	chara.target_position += $TileMap.cell_size/2
	
	# set the original_position
	character_original_position = chara.map_position
	
	character = chara


func character_movement_input():
	if Input.is_action_just_pressed("ui_up"):
		movement_queue.append(Vector2.UP)
	if Input.is_action_just_pressed("ui_down"):
		movement_queue.append(Vector2.DOWN)
	if Input.is_action_just_pressed("ui_left"):
		movement_queue.append(Vector2.LEFT)
	if Input.is_action_just_pressed("ui_right"):
		movement_queue.append(Vector2.RIGHT)
	
	if Input.is_action_just_pressed("ui_accept"):
		emit_signal("scene_finished")


func character_movement():
	#remove uneeded inputs from the queue
	for i in len(movement_queue) - 1:
		#remove if adjacent values are opposites
		if (movement_queue[i].x * movement_queue[i+1].x == -1 or
			movement_queue[i].y * movement_queue[i+1].y == -1):
				movement_queue[i] = Vector2.ZERO
				movement_queue[i+1] = Vector2.ZERO
	#remove null values
	for i in len(movement_queue):
		if movement_queue.find(Vector2.ZERO) != -1:
			movement_queue.remove(movement_queue.find(Vector2.ZERO))
	
	if len(movement_queue) == 0:
		return
	
	if not character.moving:
		
		var total_distance = character.map_position + movement_queue[0]
		total_distance -= character_original_position
		
		#if the character is moving too far, cancel movement and empty queue
		if total_distance.length() > character_movement_range:
			movement_queue = []
			return
		
		#move the character once space in the queue if not moving
		character.map_position += movement_queue.pop_front()
		character.target_position = $TileMap.map_to_world(character.map_position)
		character.target_position += $TileMap.cell_size/2 


func _physics_process(_delta):
	if not active:
		return
	
	character_movement()
	character_movement_input()
