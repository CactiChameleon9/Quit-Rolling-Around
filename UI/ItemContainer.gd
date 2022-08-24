extends Control

signal scene_finished
signal scene_failed

var active : bool = false

export (PackedScene) var item_view_scene
export (NodePath) var child_holder
export (String) var character_property = "items"
export (String) var view_property = "item"

var character : Character = Character.new() setget update_items_shown
var item_views = []

var hovering_view : int = -1

func update_items_shown(new_character = null):
	
	# allow the update item shown function to work with and without setget
	if new_character != null:
		character = new_character
	
	# remove the old items
	for item_view in item_views:
		yield(item_view.item_view_remove(false), "completed")
	item_views = []
	
	# add items the new items from the character
	for item in character.get(character_property):
		var new_item_view = item_view_scene.instance()
		new_item_view.set(view_property, item)
		get_node(child_holder).add_child(new_item_view)
		item_views.append(new_item_view)
		new_item_view.connect("item_view_removed", self, "remove_from_item_views")


func remove_from_item_views(item_view):
	var to_remove : int = item_views.find(item_view)
	if to_remove != -1:
		item_views.remove(to_remove)


func _physics_process(_delta):
	if not active:
		hovering_view = -1
		return
	
	# set the hovering view if just selected
	if hovering_view == -1:
		hovering_view = 0
		item_views[hovering_view].hovering = false
	
	# move the selection forward or backward the list depending on input
	if (Input.is_action_just_pressed("ui_down") or 
		Input.is_action_just_pressed("ui_right")):
			
			# disable hovering on the previous item
			item_views[hovering_view].hovering = false
			
			# cycle forward
			hovering_view += 1
			if hovering_view >= len(item_views):
				hovering_view = 0
			
			# enable hovering on the present item
			item_views[hovering_view].hovering = true
	
	if (Input.is_action_just_pressed("ui_up") or
		Input.is_action_just_pressed("ui_left")):
			
			item_views[hovering_view].hovering = false
			
			hovering_view -= 1
			if hovering_view < 0:
				hovering_view = len(item_views) -1
			
			item_views[hovering_view].hovering = true
	
	
