tool
extends Control

const dice_image_string = "res://Assets/Dice/Dice%s.png"
const selected_shader = preload("res://UI/RainbowOutline.tres")

export (int, 0, 6) var dice_value : int = 0
export var selected : bool setget set_selected


func set_selected(new_value):
	selected = new_value
	if selected:
		self.material = selected_shader
	else:
		self.material = null


func _physics_process(_delta):
	self.texture = load(dice_image_string % dice_value)


