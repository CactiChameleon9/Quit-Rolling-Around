extends Node2D
class_name Character

export var base_max_health : int = 20
export (int, 1, 5) var level : int = 1 setget level_change

var health


var map_position : Vector2 = Vector2.ZERO
onready var target_position : Vector2 = position
var moving : bool = false


func level_change(new_level):
	# when leveing up restore health
	health = base_max_health * pow(level, 1.5)


func _physics_process(delta):
	
	# If the 2 positions are close enough, then not moving
	moving = false if target_position.round() == position.round() else true
	
	if not moving: return
	
	#TODO: Replace with tween magic
	position += (target_position - position)/2.5

func take_damage(damage):
	health -= damage
	if health <= 0:
		die()

func die():
	#Animation here
	queue_free()
