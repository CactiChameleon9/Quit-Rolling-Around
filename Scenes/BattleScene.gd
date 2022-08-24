extends Node


func _ready():
	$"%Battle".character = $Player
	$"%CardContainer".character = $Player
	$"%DiceContainer".character = $Player
