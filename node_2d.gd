extends Node2D

@onready var pause_menu = $CanvasLayer/PauseMenu

var paused = false

var held_object = false
var onGround = false

@onready var box_hit = $"Box Drop"

func _ready():
	print($TileMap.get_cell_source_id(0, Vector2i(-5, -5)))
	for node in get_tree().get_nodes_in_group("pickable"):
		node.clicked.connect(_on_pickable_clicked)
func _on_pickable_clicked(object):
	if !held_object:
		object.pickup()
		held_object = object
		
func _unhandled_input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if held_object and !event.pressed:
			held_object.drop(Input.get_last_mouse_velocity() / 5.0)
			held_object = null

func _process(delta):
	if Input.is_action_just_pressed("pause"):
		_pause_menu()
		
func _pause_menu():
	if paused:
		pause_menu.hide()
		get_tree().paused = false
	else:
		pause_menu.show()
		
		get_tree().paused = true
	
	paused = !paused
func _on_scaling_box_mouse_entered():
	pass # Replace with function body.

func _hit():
	box_hit.play()

func _on_box_body_entered(body):
	if $Box.body_entered() :
		if not onGround:
			_hit()
		onGround = true
	else:
		onGround = false
