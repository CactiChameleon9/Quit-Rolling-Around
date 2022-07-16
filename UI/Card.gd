tool
extends Control

export (Resource) var card_info


const TYPE_COLORS = [
	Color("#db4758"), # DAMAGE
	Color("#3cc361"), # UTILITY
	Color("#ddd55c"), # SPECIAL
	Color("#bc5ec6"), # EFFECT
	Color("#a4a4a4"), # MOVEMENT
]

func _ready():

	# change the color of the panel to match the appropriate type
	var card_style = $PanelContainer.get('custom_styles/panel').duplicate(true)
	card_style.set_bg_color(TYPE_COLORS[card_info.type])
	$PanelContainer.set('custom_styles/panel', card_style)
