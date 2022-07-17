extends Control

signal return_dice(dice_number)
signal do_movement(movement_range)
signal do_damage(damage, damage_range)
signal do_effect(effect, effect_range)

const card = preload("res://UI/Card.tscn")
const card_db_string = "res://Assets/CardDB/%s.tres"


var selected : bool = false
var hovering_card = null

var current_cards = []

var currently_holding_dice = null


func emit_return_dice(dice_number):
	emit_signal("return_dice", dice_number)
func emit_do_movement(movement_range):
	emit_signal("do_movement", movement_range)
func emit_do_damage(damage, damage_range):
	emit_signal("do_damage", damage, damage_range)
func emit_do_effect(effect, effect_range):
	emit_signal("do_effect", effect, effect_range)


func set_currently_holding_dice(dice_number : int):
	currently_holding_dice = dice_number


func remove_card(card):
	var card_index = current_cards.find(card)
	current_cards.remove(card_index)


func _physics_process(delta):
	
	# no keyboard input if not selected  
	if not selected:
		hovering_card = null
		return
	
	# if selected card is null, add a value
	if not hovering_card:
		hovering_card = 0
	
	# move the selection forward or backward the list depending on input
	if (Input.is_action_just_pressed("ui_down") or 
		Input.is_action_just_pressed("ui_right")):
			
			current_cards[hovering_card].hovering_dice = null
			
			hovering_card += 1
			if hovering_card >= len(current_cards):
				hovering_card = 0
	
	if (Input.is_action_just_pressed("ui_up") or
		Input.is_action_just_pressed("ui_left")):
			
			current_cards[hovering_card].hovering_dice = null
			
			hovering_card -= 1
			if hovering_card < 0:
				hovering_card = len(current_cards) -1
	
	# show the dice over the card if hovering
	current_cards[hovering_card].hovering_dice = currently_holding_dice
	
	#if the enter key is pressed, input the dice into the card
	if Input.is_action_just_pressed("ui_accept"):
		current_cards[hovering_card].hovering_dice = null
		current_cards[hovering_card].dice_inputted(currently_holding_dice)
		hovering_card = 0
		selected = false


func draw_card(specific_card : String = ""):
	# make a new card instance and add it to the grid container
	var new_card = card.instance()
	$Margin/HBox.add_child(new_card)
	
	# check if a specific card data exists
	var card_data_check = File.new()
	var card_data_exists : bool = card_data_check.file_exists(card_db_string % specific_card)

	# if a specifc card choosen, make new card that type
	if card_data_exists:
		new_card.card_info = load(card_db_string % specific_card)
	else: #no card choosen, pick default
		new_card.card_info = load(card_db_string % "Default")
	
	# connect new_card.x signal to self.x 
	new_card.connect("return_dice", self, "emit_return_dice")
	new_card.connect("do_movement", self, "emit_do_movement")
	new_card.connect("do_damage", self, "emit_do_damage")
	new_card.connect("do_effect", self, "emit_do_effect")
	
	# connect the signal remove card signal
	new_card.connect("card_removed", self, "remove_card")
	
	# add the current card to the list of card
	current_cards.append(new_card)
