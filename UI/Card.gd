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
var addition_dice_amount : int setget _set_addition_dice


func _set_addition_dice(new_amount):
	$VBox/AutoGrid/InputDice0/Number.text = String(new_amount)


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
	
	#maybe set the addition amount
	if card_info.addition_dice:
		self.addition_dice_amount = card_info.addition_amount


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
		self.addition_dice_amount -= dice_number
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
	for dice_number in input_dice:
		damage += card_info.damage_dice_multiplyer * dice_number
	
	# do any utility dice returns
	for dice_number in input_dice:
		
		if card_info.EFFECT.SPLIT in card_info.effects:
			var halfed_dice = float(dice_number)/2.0
			
			var new_dice1 = halfed_dice
			var new_dice2 = halfed_dice
			
			#if decimal value, then minus half and add half
			if halfed_dice % 1 != 0:
				new_dice1 -= 0.5
				new_dice2 += 0.5
			
			emit_signal("return_dice", new_dice1)
			emit_signal("return_dice", new_dice1)
		
		if card_info.EFFECT.DOUBLE in card_info.effects:
			var new_dice1 = dice_number * 2
			var new_dice2 = 0
			
			#dice has to be smaller than 7
			if new_dice1 > 6:
				new_dice1 -= 6
				new_dice2 = 6
				
			emit_signal("return_dice", new_dice1)
			if new_dice2 != 0: emit_signal("return_dice", new_dice1)
		
		if card_info.EFFECT.HALF in card_info.effects:
			var new_dice = float(dice_number)/2.0
			
			#if decimal valued, add 0.5 or - 0.5 at random
			if new_dice % 1 != 0:
				new_dice += round(randf()) - 0.5
				
			emit_signal("return_dice", new_dice)
		
		if card_info.EFFECT.FLIP in card_info.effects:
			# all opposite sides of a dice add up to 7
			emit_signal("return_dice", 7 - dice_number)
		
		if card_info.EFFECT.DUPLICATE in card_info.effects:
			emit_signal("return_dice", dice_number)
			emit_signal("return_dice", dice_number)
		
	
	#clear the input dice
	input_dice = []
	
	#card is used, disappear
	queue_free()

