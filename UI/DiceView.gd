extends Control

const dice = preload("res://UI/Dice.tscn")

var current_dice = []

func roll_dice(specific_value : int = 0):
	# make a new dice instance and add it to the grid container
	var new_dice = dice.instance()
	$Margin/AutoGrid.add_child(new_dice)
	
	# if a specifc dice choosen, make new dice that type
	if specific_value in [1, 2, 3, 4, 5, 6]:
		new_dice.dice_value = specific_value
	
	# add the current dice to the list of dice
	current_dice.append(new_dice)
