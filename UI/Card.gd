tool
extends Control

signal return_dice(dice_number)

const TYPE_COLORS = [
	Color("#db4758"), # DAMAGE
	Color("#3cc361"), # UTILITY
	Color("#bcb64f"), # SPECIAL
	Color("#bc5ec6"), # EFFECT
	Color("#a4a4a4"), # MOVEMENT
]


export (Resource) var card_info

var input_dice = []

func _ready():

	# change the color of the panel to match the appropriate type
	var card_style = $PanelContainer.get('custom_styles/panel').duplicate(true)
	card_style.set_bg_color(TYPE_COLORS[card_info.type])
	$PanelContainer.set('custom_styles/panel', card_style)
	
	# add more input dice if needed
	for i in range(1, card_info.number_of_dice):
		var new_input_dice = get_node("VBox/AutoGrid/InputDice0").duplicate(true)
		new_input_dice.name = "InputDice%s" % i
		$VBox/AutoGrid.add_child(new_input_dice)
	
	# change the name and description
	$VBox/Name.text = card_info.name
	$VBox/Description.text = card_info.description
	

func dice_inputted(dice_number : int):
	#check if dice is within dice range
	if dice_number >= 1 and dice_number <= 6:
		return
	
	#if accepted dice is specified, check if the dice is in the list
	if (len(card_info.accepted_dice) != 0 and
		not dice_number in card_info.accepted_dice):
		emit_signal("return_dice", dice_number)
		return
	
	
	input_dice.append(dice_number)
	
	if len(input_dice) == card_info.number_of_dice:
		run_card()

func run_card():
	pass
