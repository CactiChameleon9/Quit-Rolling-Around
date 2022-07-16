tool
extends Control


enum TYPE {
	DAMAGE = 0
	UTILITY = 1
	SPECIAL = 2
	EFFECT = 3
}

const TYPE_COLORS = [
	Color("#db4758"), # DAMAGE
	Color("#3cc361"), # UTILITY
	Color("#ddd55c"), # SPECIAL
	Color("#bc5ec6"), # EFFECT
]

export (TYPE) var type


func _ready():
	var card_style = $PanelContainer.get('custom_styles/panel').duplicate(true)
	card_style.set_bg_color(TYPE_COLORS[type])
	$PanelContainer.set('custom_styles/panel', card_style)
