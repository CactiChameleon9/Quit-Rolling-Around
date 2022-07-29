extends Control

const card_view_scene = preload("res://UI/CardView.tscn")

var character : Character = Character.new() setget update_cards_shown
var card_views = []


func update_cards_shown(new_character = null):
	
	# allow the update card shown function to work with and without setget
	if new_character != null:
		character = new_character
	
	# remove the old cards
	for card_view in card_views:
		yield(card_view.card_view_remove(), "completed")
	
	# add cards the new cards from the character
	for card in character.cards:
		var new_card_view = card_view_scene.instance()
		new_card_view.card = card
		$Margin/HBox.add_child(new_card_view)
		card_views.append(new_card_view)
