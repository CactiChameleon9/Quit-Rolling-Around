tool
extends Control

const dice_image_string = "res://Assets/Dice/Dice%s.png"
const hovering_shader = preload("res://UI/RainbowOutline.tres")

export (int, 0, 6) var dice_value : int = 0
export var hovering : bool setget set_hovering


func set_hovering(new_value):
	hovering = new_value
	if hovering:
		self.material = hovering_shader
	else:
		self.material = null


func _physics_process(_delta):
	self.texture = load(dice_image_string % dice_value)


