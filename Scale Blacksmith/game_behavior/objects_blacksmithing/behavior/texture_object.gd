extends Sprite

export(Texture) var item_focus

onready var main_texture = texture

func focus_object():
	
	if item_focus == null: return
	
	texture = item_focus
	
func remove_focus():
	
	texture = main_texture
