extends Node2D

var movement_queue = []

var player_to_move : bool = false
var player_original_position : Vector2 = Vector2.ZERO
var player_movement_range = 5

func _physics_process(delta):
	
	# player should carry on queued movements no matter what
	player_movement()
	
	# note down the player position before moving
	if not player_to_move:
		player_original_position = $Player.map_position
	
	# if the player needs to move, allow the input to be for the player
	if player_to_move:
		player_movement_input()
		return
	
	# select the card chooser if dice is selected
	if (Input.is_action_just_pressed("ui_accept")
		and $UI/DiceView.selected == true):
		$UI/DiceView.selected = false
		$UI/CardView.selected = true


func player_movement_input():
	if Input.is_action_just_pressed("ui_up"):
		movement_queue.append(Vector2.UP)
	if Input.is_action_just_pressed("ui_down"):
		movement_queue.append(Vector2.DOWN)
	if Input.is_action_just_pressed("ui_left"):
		movement_queue.append(Vector2.LEFT)
	if Input.is_action_just_pressed("ui_right"):
		movement_queue.append(Vector2.RIGHT)
	
	if Input.is_action_just_pressed("ui_accept"):
		player_to_move = false


func player_movement():
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
	
	if not $Player.moving:
		#if the player is moving too far, cancel movement and empty queue
		if (($Player.map_position + movement_queue[0]
			- player_original_position).length() > player_movement_range):
			movement_queue = []
			return
		
		#move the character once space in the queue if not moving
		$Player.map_position += movement_queue.pop_front()
		$Player.target_position = $TileMap.map_to_world($Player.map_position)
		$Player.target_position += $TileMap.cell_size/2
