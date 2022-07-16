extends Node2D

var movement_queue = []

func _physics_process(delta):
	
	if Input.is_action_just_pressed("ui_up"):
		movement_queue.append(Vector2.UP)
	if Input.is_action_just_pressed("ui_down"):
		movement_queue.append(Vector2.DOWN)
	if Input.is_action_just_pressed("ui_left"):
		movement_queue.append(Vector2.LEFT)
	if Input.is_action_just_pressed("ui_right"):
		movement_queue.append(Vector2.RIGHT)
	
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
	
	
	
