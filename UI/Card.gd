extends Node
class_name Card

signal return_dice(dice_number)
signal do_movement(movement_range)
signal do_damage(damage, damage_range)
signal do_effect(effect, effect_range)
signal card_removed()

export (Resource) var card_info = preload("res://Assets/CardDB/Default.tres")

var input_dice = []
var addition_dice_amount = card_info.addition_amount

func dice_inputted(dice_number):
	
	# -- SINGLE DICE CHECKS --
	if dice_number == null:
		return
	
	#check if dice is within dice range
	if dice_number < 1 and dice_number > 6:
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
	
	# if the addition type, then lower the counter by the input dice
	# also check (and run) if the amount is reaches and
	if card_info.addition_dice:
		
		addition_dice_amount -= dice_number
		
		if addition_dice_amount <= 0:
			run_card()
		return
	
	# run the card if the correct number of dice have been inputted (and normal dice)
	if (len(input_dice) == card_info.number_of_dice
		and not card_info.addition_dice):
		run_card()


func run_card():
	# calculate the damage amount
	var damage = card_info.damage_amount_addition
	for dice_number in input_dice:
		damage += card_info.damage_dice_multiplyer * dice_number
	
	if damage != 0:
		emit_signal("do_damage", damage, card_info.effect_damage_range)
	
	# calculate the damage amount
	var movement = card_info.move_amount_addition
	for dice_number in input_dice:
		movement += card_info.move_dice_multiplyer * dice_number
	
	if movement != 0:
		emit_signal("do_movement", movement)
	
	# do any utility dice returns
	for dice_number in input_dice:
		
		if Global.EFFECT.SPLIT in card_info.effects:
			var halfed_dice = float(dice_number)/2.0
			
			var new_dice1 = halfed_dice
			var new_dice2 = halfed_dice
			
			#if decimal value, then minus half and add half
			if decimals(halfed_dice) != 0:
				new_dice1 -= 0.5
				new_dice2 += 0.5
			
			emit_signal("return_dice", new_dice1)
			emit_signal("return_dice", new_dice2)
		
		if Global.EFFECT.DOUBLE in card_info.effects:
			var new_dice1 = dice_number * 2
			var new_dice2 = 0
			
			#dice has to be smaller than 7
			if new_dice1 > 6:
				new_dice1 -= 6
				new_dice2 = 6
				
			emit_signal("return_dice", new_dice1)
			if new_dice2 != 0: emit_signal("return_dice", new_dice1)
		
		if Global.EFFECT.HALF in card_info.effects:
			var new_dice = float(dice_number)/2.0
			
			#if decimal valued, add 0.5 or - 0.5 at random
			if decimals(new_dice) != 0:
				new_dice += round(randf()) - 0.5
				
			emit_signal("return_dice", new_dice)
		
		if Global.EFFECT.FLIP in card_info.effects:
			# all opposite sides of a dice add up to 7
			emit_signal("return_dice", 7 - dice_number)
		
		if Global.EFFECT.DUPLICATE in card_info.effects:
			emit_signal("return_dice", dice_number)
			emit_signal("return_dice", dice_number)
	
	# for each effect, emit do effect with the range
	for effect in card_info.effects:
		emit_signal("do_effect", effect, card_info.effect_damage_range)
	
	
	#clear the input dice
	input_dice = []
	
	#card is used, disappear
	emit_signal("card_removed")
	queue_free()

