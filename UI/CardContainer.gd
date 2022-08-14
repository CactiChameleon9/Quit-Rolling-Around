extends Control

signal scene_finished
signal scene_failed

var active : bool = false

const card_view_scene = preload("res://UI/CardView.tscn")

var character : Character = Character.new() setget update_cards_shown
var card_views = []


func update_cards_shown(new_character = null):
	
	# allow the update card shown function to work with and without setget
	if new_character != null:
		character = new_character
	
	# remove the old cards
	for card_view in card_views:
		yield(card_view.card_view_remove(false), "completed")
	card_views = []
	
	# add cards the new cards from the character
	for card in character.cards:
		var new_card_view = card_view_scene.instance()
		new_card_view.card = card
		$Margin/HBox.add_child(new_card_view)
		card_views.append(new_card_view)
		new_card_view.connect("card_view_removed", self, "remove_from_card_views")


func remove_from_card_views(card_view):
	var to_remove : int = card_views.find(card_view)
	if to_remove != -1:
		card_views.remove(to_remove)
