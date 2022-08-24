extends Control

signal card_view_removed(card_view)

const TYPE_COLORS = [
	Color("#db4758"), # DAMAGE
	Color("#3cc361"), # UTILITY
	Color("#bcb64f"), # SPECIAL
	Color("#bc5ec6"), # EFFECT
	Color("#a4a4a4"), # MOVEMENT
]

const input_dice_view = preload("res://UI/InputDiceView.tscn")
var input_dice_views = []

var hovering : bool  = false setget set_hovering

var card : Card = Card.new() setget update_cardview


func update_cardview(new_card = null):
	
	# allow the update card function to work with and without setget
	if new_card != null and new_card != card:
		disconnect_signals()
		card = new_card
		connect_signals()
	
	# change the color of the panel to match the appropriate type
	var card_style = $"%Background".get('custom_styles/panel').duplicate(true)
	card_style.set_bg_color(TYPE_COLORS[card.card_info.type])
	$"%Background".set('custom_styles/panel', card_style)
	
	# change the name and description
	$"%Name".text = card.card_info.name
	$"%Description".text = card.card_info.description
	
	# remove the old input dice views
	for i in input_dice_views:
		i.queue_free()
	input_dice_views = []
	
	# add the correct number of input dice views
	for i in card.card_info.number_of_dice:
		add_input_dice_view()
	
	# set the extra info
	var extra_text = ""
	if card.card_info.addition_dice == true:
		# set the dice to have the remaining addition 
		extra_text = str(card.addition_dice_amount)
	
	else:
		# set the dice to have a list of accepted dice
		for dice in card.card_info.accepted_dice:
			extra_text += str(dice) + ", "
		extra_text = extra_text.trim_suffix(", ")
	
	for i in input_dice_views:
		i.set_extra_info(extra_text)
	
	# set bold dice if addition dice
	if card.card_info.addition_dice == true:
		for i in input_dice_views:
			i.bold = true
	
	#TODO: same dice UI support
	#TODO: hover UI support maybe


# add an input_dice_view to the array (for easy management)
# and to the autogrid
func add_input_dice_view():
	var dice_view = input_dice_view.instance() 
	input_dice_views.append(dice_view)
	$"%AutoGrid".add_child(dice_view)


# this is run once the card emits card_removed
func card_view_run(do_emit_signal : bool = true):
	# emit card_view_removed signal
	if do_emit_signal: emit_signal("card_view_removed", self)
	
	# play the disappearing input dice animation
	play_input_dice_animations()
	
	# play the using animation
	$AnimationPlayer.play("Fly Off")
	yield($AnimationPlayer, "animation_finished")
	
	# remove the card completely once used
	queue_free()


func card_view_remove(do_emit_signal : bool = true):
	# emit card_view_removed signal
	if do_emit_signal: emit_signal("card_view_removed", self)

	# play the remove animation
	$AnimationPlayer.play("Drop Off")
	yield($AnimationPlayer, "animation_finished")
	
	# remove the card completely once used
	queue_free()


func play_input_dice_animations():
	for i in input_dice_views:
		i.run_disappear_animation()


func disconnect_signals():
	if card.get_signal_connection_list("card_removed") == []:
		return
	
	card.disconnect("card_removed", self, "card_view_run")


func connect_signals():
	card.connect("card_removed", self, "card_view_run")


func set_hovering(value : bool):
	# set the hovering value
	hovering = value
	
	# wait until the old animation is finished
	if ($AnimationPlayer.current_animation != "Hovering"
		and $AnimationPlayer.current_animation != ""):
		yield($AnimationPlayer, "animation_finished")
	
	if hovering:
		$AnimationPlayer.play("Hovering")
	
	if not hovering:
		$AnimationPlayer.play("RESET")
