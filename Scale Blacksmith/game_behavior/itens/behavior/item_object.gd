extends Area2D
class_name DragDropData

signal itemDrop(position , item)
signal itemDrag(position , item)

onready var texture = $"texture"

var item_data:MetaItem = preload("res://custom_data/resources/itens/test.tres")

var start_move = false

var get = false
var on_area = false

var can_drop = false

var pos_drag:Vector2
var pos_drop:Vector2

var item_block = false

func _ready():
	
	_set_data()

func _set_data():
	
	if item_data == null: return
	
	texture.texture = item_data.icon

func _emit(signal_name:String):
	
	emit_signal(signal_name , item_data , global_position)

func _on_item_mouse_entered():
	
	on_area = true

func _on_item_mouse_exited():
	
	on_area = false

func _input(event):
	
	if item_block == false:
	
		if event is InputEventMouseButton:
			
			if event.button_index == 1 and on_area == true:
				
				get = event.pressed
				
		elif event is InputEventMouseMotion:
			
			if get == true:
				
				global_position = event.position

func _process(delta):
	
	match get:
		
		true:
			
			if start_move == false:
				
				start_move = true
				
				pos_drag = global_position
				
				_emit("itemDrag")
				
		false:
			
			if start_move == true:
				
				match can_drop:
					
					true:
						
						start_move = false
						
						pos_drop = global_position
						
						_emit("itemDrop")
						
					false:
						
						global_position = pos_drag
