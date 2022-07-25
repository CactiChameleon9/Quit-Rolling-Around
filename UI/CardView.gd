extends Control

const TYPE_COLORS = [
	Color("#db4758"), # DAMAGE
	Color("#3cc361"), # UTILITY
	Color("#bcb64f"), # SPECIAL
	Color("#bc5ec6"), # EFFECT
	Color("#a4a4a4"), # MOVEMENT
]

const input_dice_view = preload("res://UI/InputDiceView.tscn")
var input_dice_views = []

var card : Card = Card.new() setget update_cardview


func _ready():
	update_cardview()


func update_cardview(new_card = null):
	
	# allow the update card function to work with and without setget
	if new_card != null:
		card = new_card
	
	# change the color of the panel to match the appropriate type
	var card_style = $Background.get('custom_styles/panel').duplicate(true)
	card_style.set_bg_color(TYPE_COLORS[card.card_info.type])
	$Background.set('custom_styles/panel', card_style)
	
	# change the name and description
	$VBox/Name.text = card.card_info.name
	$VBox/Description.text = card.card_info.description
	
	# add the correct number of input dice views
	for i in card.card_info.number_of_dice:
		add_input_dice_view()


# add an input_dice_view to the array (for easy management)
# and to the autogrid
func add_input_dice_view():
	var dice_view = input_dice_view.instance() 
	input_dice_views.append(dice_view)
	$"%AutoGrid".add_child(dice_view)
