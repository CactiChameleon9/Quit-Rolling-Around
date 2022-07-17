extends Resource
class_name CardResource

enum TYPE {
	DAMAGE
	UTILITY
	SPECIAL
	EFFECT
	MOVEMENT
}

enum ACCEPTED_DICE {
	DICE_1
	DICE_2
	DICE_3
	DICE_4
	DICE_5
	DICE_6
}

export (String) var name = ""

export (TYPE) var type

export (int) var effect_damage_range = 0

export (int) var move_amount_addition
export (int) var move_dice_multiplyer

export (int) var damage_amount_addition
export (int) var damage_dice_multiplyer

export (Array, Global.EFFECT) var effects

export (Array, ACCEPTED_DICE) var accepted_dice

export (int) var number_of_dice = 1
export (bool) var same_dice_requirement = false

export (bool) var addition_dice = false
export (int) var addition_amount = -1

export (String, MULTILINE) var description = ""

