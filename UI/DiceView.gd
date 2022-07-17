extends Control

signal dice_selected (dice_value)

const dice = preload("res://UI/Dice.tscn")

var selected : bool = false
var selected_dice = null

var current_dice = []


func _physics_process(delta):
	
	# no keyboard input if not selected  
	if not selected:
		selected_dice = null
		return
	
	# if selected dice is null, add a value
	if not selected_dice:
		selected_dice = 0
	
	# TODO: maybe support actual dicrectional selection
	# move the selection forward or backward the list depending on input
	if (Input.is_action_just_pressed("ui_up") or 
		Input.is_action_just_pressed("ui_left")):
			
			current_dice[selected_dice].selected = false
			
			selected_dice += 1
			if selected_dice >= len(current_dice):
				selected_dice = 0
	
	if (Input.is_action_just_pressed("ui_down") or
		Input.is_action_just_pressed("ui_right")):
			
			current_dice[selected_dice].selected = false
			
			selected_dice -= 1
			if selected_dice < 0:
				selected_dice = len(current_dice) -1
	
	# enable the selected shader
	current_dice[selected_dice].selected = true
	
	#if the enter key is pressed, remove the selected dice and emit the signal
	if Input.is_action_just_pressed("ui_accept"):
		emit_signal("dice_selected", current_dice[selected_dice].dice_value)
		
		current_dice[selected_dice].queue_free()
		current_dice.remove(selected_dice)
		selected_dice = null


func roll_dice(specific_value : int = 0):
	# make a new dice instance and add it to the grid container
	var new_dice = dice.instance()
	$Margin/AutoGrid.add_child(new_dice)
	
	# if a specifc dice choosen, make new dice that type
	if specific_value in [1, 2, 3, 4, 5, 6]:
		new_dice.dice_value = specific_value
	
	# add the current dice to the list of dice
	current_dice.append(new_dice)
