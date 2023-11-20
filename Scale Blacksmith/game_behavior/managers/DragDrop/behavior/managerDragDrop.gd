extends Node
class_name itemDragDrop

signal itemDrop(position , item)
signal itemDrag(position , item)

onready var item = $"item"

var item_data:MetaItem

var start_move = false

var get = false
var on_area = false

var can_drop = false

var pos_drag:Vector2
var pos_drop:Vector2

func _emit(signal_name:String):
	
	emit_signal(signal_name , item_data , item.global_position)

func _on_item_mouse_entered():
	
	on_area = true

func _on_item_mouse_exited():
	
	on_area = false

func _input(event):
	
	if event is InputEventMouseButton:
		
		if event.button_index == 1 and on_area == true:
			
			get = event.pressed
			
	elif event is InputEventMouseMotion:
		
		if get == true:
			
			item.global_position = event.position

func _process(delta):
	
	match get:
		
		true:
			
			if start_move == false:
				
				start_move = true
				
				pos_drag = item.global_position
				
				_emit("itemDrag")
				
		false:
			
			if start_move == true:
				
				match can_drop:
					
					true:
						
						start_move = false
						
						pos_drop = item.global_position
						
						_emit("itemDrop")
						
					false:
						
						item.global_position = pos_drag


func _on_managerDragDrop_itemDrag(position, item):
	
	print(position , item)


func _on_managerDragDrop_itemDrop(position, item):
	
	print(position , item)
