tool
extends Control

const dice_image_string = "res://Assets/Dice/Dice%s.png"
const selected_shader = preload("res://UI/RainbowOutline.tres")

export (int, 1, 6) var dice_value : int setget _set_dice_value
export var selected : bool setget _set_selected


func _set_selected(new_value):
	selected = new_value
	if selected:
		self.material = selected_shader
	else:
		self.material = null


func _set_dice_value(new_value):
	dice_value = new_value
	self.texture = load(dice_image_string % new_value)


func _ready():
	randomize()
	
	self.dice_value = int(round(rand_range(0.5, 6.49999999)))


