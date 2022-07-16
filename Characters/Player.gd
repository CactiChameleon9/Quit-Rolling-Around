extends Node2D

export var map_position : Vector2 = Vector2.ZERO

var target_position : Vector2 = Vector2.ZERO
var moving : bool = false


func _physics_process(delta):
	
	# If the 2 positions are close enough, then not moving
	moving = false if target_position.round() == position.round() else true
	
	if not moving: return
	
	#TODO: Replace with tween magic
	position += (target_position - position)/2.5
