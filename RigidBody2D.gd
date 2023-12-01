extends RigidBody2D

var box_texture = load("res://Textures/box_wood.png")
var box_transparent = load("res://Textures/box_wood_transparent.png")
@onready var box_sprite = get_node("BoxWood")

signal clicked

enum State {
	Vertical,
	Horizontal,
	Size
}

var held = false

func _input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			#print("clicked")
			clicked.emit(self)

func _box_collision():
	pass

func _physics_process(delta):
	if held:
		global_transform.origin = get_global_mouse_position()
		
func pickup():
	if held:
		return
	box_sprite.set_texture(box_transparent)
	set_collision_layer(8)
	set_collision_mask(6)
	freeze = true
	held = true
	
func drop(impulse=Vector2.ZERO):
	if held:
		box_sprite.set_texture(box_texture)
		set_collision_layer(4)
		set_collision_mask(7)
		freeze = false
		apply_central_impulse(impulse)
		held = false


func _on_body_entered(body):
	pass # Replace with function body.
