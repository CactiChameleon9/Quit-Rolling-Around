tool
extends Control

func _process(_delta):
	
	# update the pivot offset to make sure the object's animations
	# are always centered 
	$Sprite.rect_pivot_offset = rect_size/2
	$Particles2D.position = rect_size/2
