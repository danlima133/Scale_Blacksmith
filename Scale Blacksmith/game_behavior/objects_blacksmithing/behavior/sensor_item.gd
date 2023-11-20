extends Area2D

signal move_finished

enum ObjetcType {
	Anvil,
	Table,
	Furnace,
	Storage,
	Miner,
	Sawyer
}

export(ObjetcType) var my_type

export(NodePath) var texture_object

var my_item:MetaItem

var item_object

var removing_item = false

onready var correct_position = $"pos_item"

func _ready():
	
	texture_object = get_node(texture_object)

func removing_item(item):
	
	removing_item = true
	
	item.get = false
	
	var anim = get_tree().create_tween()
	
	anim.tween_property(item , "global_position" , item.pos_drag , 0.2)
	
#	item.global_position = item.pos_drag

func put_item(item):
	
	texture_object.focus_object()
	
	item.can_drop = true
	
	item.get = false
	
	item_object = item
	
	if my_item == null:
	
		item.connect("itemDrop" , self , "_item_drop" , [item])
	
	my_item = item.item_data

func remove_item(item):
	
	my_item = null
	
	item_object = null
	
	texture_object.remove_focus()
		
	item.can_drop = false
		
	item.disconnect("itemDrop" , self , "_item_drop")

func _on_sensor_item_area_entered(area:Area2D):
	
	if not area.is_in_group("sensor"):
	
		if my_type == ObjetcType.Anvil or my_type == ObjetcType.Miner:
			
			removing_item(area)
			
			return
		
		elif my_type == ObjetcType.Storage:
			
			area.item_block = true
			
			texture_object.focus_object()
	
			area.can_drop = true
	
			area.get = false
	
			item_object = area
			
			my_item = area.item_data
			
#			anim_pos(item_object)
#
#			yield(get_tree().create_timer(0.2) , "timeout")
			
			item_object.queue_free()
			
			my_item = null
			
			item_object = null

			return
		
		elif my_type == ObjetcType.Sawyer:
			
			if item_object == null:
				
				put_item(area)
				
				area.can_drop = true
				
				anim_pos(item_object)
				
				yield(self , "move_finished")
				
				area.item_block = true
				
				yield(get_tree().create_timer(1) , "timeout")
				
				print("Ready")
				
				if item_object != null:
				
					item_object.item_block = false
				
				return
			
			else:

				removing_item(area)
		
		elif my_type == ObjetcType.Furnace:
			
			if area.modulate != Color.red and item_object == null:
			
				texture_object.focus_object()
		
				area.can_drop = true
		
				area.get = false
		
				item_object = area
				
				my_item = area.item_data
		
				anim_pos(item_object)
				
				yield(self , "move_finished")
				
				area.item_block = true

				yield(get_tree().create_timer(1) , "timeout")
				
				area.modulate = Color.red
				
				area.item_block = false
			
			else:
				
				removing_item(area)

			return
	
	else:
		
		return
	
	if area.is_in_group("ItemData") and item_object == null:
		
		put_item(area)
		
		anim_pos(item_object)
	
	else:
		
		removing_item(area)

func _on_sensor_item_area_exited(area:Area2D):
	
	if removing_item == true:
		
		removing_item = false
		
		return
	
	if area.is_in_group("ItemData"):
		
		remove_item(area)

func _item_drop(item , pos , obj):
	
	if my_type == ObjetcType.Storage:

		queue_free()
	
	if my_item == item:
		
		pass
		
#		obj.global_position = correct_position.global_position

func anim_pos(object):
	
	var anim = get_tree().create_tween()
	
	anim.tween_property(object , "global_position" , correct_position.global_position , 0.2)
	
	yield(anim , "finished")
	
	emit_signal("move_finished")

func pressed(by_whom:String , event):
	
	if event is InputEventMouseButton:
		
		if event.pressed and event.button_index == 1:
			
			print(by_whom)

func _on_sensor_item_input_event(_viewport, event, _shape_idx):
	
	if item_object != null:
	
		if event is InputEventMouseButton and item_object.on_area == false:
			
			if event.pressed and event.button_index == 1:
				
				print(my_item)
	
	elif my_type == ObjetcType.Anvil:
		
		pressed("Anvil" , event)
	
	elif my_type == ObjetcType.Miner:
		
		pressed("Miner" , event)

	elif my_type == ObjetcType.Storage:
		
		pressed("Storage" , event)


func can_focus(case):
	
	if my_type == ObjetcType.Miner or my_type == ObjetcType.Anvil or my_type == ObjetcType.Storage:
		
		match case:
			
			true:
				
				texture_object.focus_object()
			
			false:
				
				texture_object.remove_focus()

func _on_sensor_item_mouse_entered():
	
	can_focus(true)


func _on_sensor_item_mouse_exited():
	
	can_focus(false)
