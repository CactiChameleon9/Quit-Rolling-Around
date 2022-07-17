extends Node2D

var movement_queue = []

var player_to_move : bool = false
var player_original_position : Vector2 = Vector2.ZERO
var player_movement_range = 5


func _ready():
	# start with the DiceView being selected 
	$UI/DiceView.selected = true
	$UI/CardView.selected = false
	self.player_to_move = false
	
	$UI/CardView.draw_card()
	$UI/CardView.draw_card()
	$UI/CardView.draw_card()
	
	$UI/DiceView.roll_dice()
	$UI/DiceView.roll_dice()
	$UI/DiceView.roll_dice()


func do_damage_around_player(damage, damage_range):
	pass

func do_effect_around_player(effect, effect_range):
	pass

func set_player_to_move(movement_range : int = 0):
	player_to_move = true
	player_movement_range = movement_range


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
		yield(get_tree().create_timer(0.1), "timeout") #TODO BAD WORKAROUND
		$UI/DiceView.selected = false
		$UI/CardView.selected = true
	
	# if all 3 parts are done, select the DiceView again
	if ($UI/DiceView.selected == false and
		$UI/CardView.selected == false and
		self.player_to_move == false):
		
		$UI/DiceView.selected = true


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
