tool
extends Control

const dice_image_string = "res://Assets/Dice/Dice%s.png"

export (int, 1, 6) var dice_value : int setget _set_dice_value

func _set_dice_value(new_value):
	dice_value = new_value
	self.texture = load(dice_image_string % new_value)


func _ready():
	randomize()
	
	self.dice_value = int(round(rand_range(0.5, 6.49999999)))
