tool
extends Control

export var bold : bool setget set_bold


func _process(_delta):
	
	# update the pivot offset to make sure the object's animations
	# are always centered 
	$Sprite.rect_pivot_offset = rect_size/2
	$Particles2D.position = rect_size/2


func set_extra_info(text : String):
	$"%ExtraInfo".text = text


func set_bold(is_bold : bool = true):
	if is_bold:
		$Sprite.texture = load("res://Assets/DiceInputBold.png")
	else:
		$Sprite.texture = load("res://Assets/DiceInput.png")
	
	bold = is_bold


func run_disappear_animation():
	$AnimationPlayer.play("Disappear")
	yield($AnimationPlayer, "animation_finished")
