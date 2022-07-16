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
var addition_dice_amount = card_info.addition_amount


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
	
	# -- SINGLE DICE CHECKS --
	#check if dice is within dice range
	if dice_number >= 1 and dice_number <= 6:
		return
	
	#if accepted dice is specified, check if the dice is in the list
	if (len(card_info.accepted_dice) != 0 and
		not dice_number in card_info.accepted_dice):
		emit_signal("return_dice", dice_number)
		return
	
	#add the dice to the input if it passes individual checks
	input_dice.append(dice_number)
	
	# -- MULTI DICE CHECKS --
	#if same dice requirement, then check if true
	if card_info.same_dice_requirement:
		var same_dice = true
		
		for i in range(1, len(input_dice)):
			if input_dice[i-1] != input_dice[i]:
				same_dice = false
				break
		
		# if not all the same dice then return all of the dice
		if not same_dice:
			for _i in len(input_dice):
				emit_signal("return_dice", input_dice[0])
				input_dice.remove(0)
	
	# -- RUN DICE CHECKS --
	if card_info.addition_dice:
		addition_dice_amount -= dice_number
		input_dice.remove(0)
		if addition_dice_amount > 0:
			return
		else:
			run_card()
	
	if (len(input_dice) == card_info.number_of_dice
		and not card_info.addition_dice):
		run_card()


func run_card():
	# calculate the damage amount
	var damage = card_info.damage_amount_addition
	for dice in input_dice:
		damage += card_info.damage_dice_multiplyer * dice
