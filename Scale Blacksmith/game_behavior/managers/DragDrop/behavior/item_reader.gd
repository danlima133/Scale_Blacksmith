extends Area2D

onready var texture = $texture

func _ready():
	
	_set_data()

func _set_data():
	
	var data = get_parent().item_data
	
	if data == null: return
	
	texture.texture = data.icon
