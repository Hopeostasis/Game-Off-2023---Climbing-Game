extends StaticBody2D

signal clicked

@export var sizeStep = 32

@onready var boxSprite: NinePatchRect = get_node("CollisionShape2D/NinePatchRect")
@onready var collisionShape: CollisionShape2D = get_node("CollisionShape2D")

@export var currentState : State 
enum State {
	Vertical,
	Horizontal,
	Scalar
}
@onready var box_scale = Vector2(0, 0)
@onready var box_spawn = Vector2(0, 0)
#@onready var spawn_pos = get_position()

var held = false
# Called when the node enters the scene tree for the first time.
func _ready():
	
	#var spawn_pos = global_position
	box_spawn = get_position()
	return
	for node in get_tree().get_nodes_in_group("Left"):
		print(node.name)
		for child in node.get_children():
			print("In Left:" + child.name)
func _input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			#print("clicked")
			clicked.emit(self)
			

# Called every frame. 'delta' is the elapsed time since the previous frame.
func pickup():
	if held:
		return
	held = true

func drop(impulse=Vector2.ZERO):
	held = false
	return
func _process(delta):
	if held:
		return

func scaling():
	if held:
		
		match currentState:
			State.Horizontal:
				box_scale = Vector2(ceil(-(box_spawn.x - get_local_mouse_position().x)/sizeStep) + 3 , 1)
				if box_scale.x != 0:
					collisionShape.shape.set_size(Vector2((abs(box_scale.x) + 3) * sizeStep, sizeStep))
					
					boxSprite.size.x = (abs(box_scale.x) + 3) * sizeStep 
					if box_scale.x > 0:
						boxSprite.position.x = snapped(box_spawn.x + boxSprite.size.x, sizeStep)
					else:
						boxSprite.position.x = snapped(box_spawn.x - boxSprite.size.x - 16, sizeStep)
					position = Vector2(snapped(box_spawn.x + ((box_scale.x ) * 16) - sizeStep, sizeStep) - 16, box_spawn.y)
					print("scaling horizontally:", box_scale)
				return
			State.Vertical:
				box_scale = Vector2(1, ceil((get_global_mouse_position().y - box_spawn.y)/sizeStep))
				if box_scale.y != 0:
					collisionShape.shape.set_size(Vector2(32, (abs(box_scale.y) + 3) * sizeStep))
					
					boxSprite.size.y = (abs(box_scale.y)) * sizeStep 
					if box_scale.y > 0:
						boxSprite.position.x = snapped(box_spawn.x + boxSprite.size.x, sizeStep)
					else:
						boxSprite.position.x = snapped(box_spawn.x - boxSprite.size.x - 16, sizeStep)
					position = Vector2(snapped(box_spawn.x + ((box_scale.x ) * 16) - sizeStep, sizeStep) - 16, box_spawn.y)
					print("scaling horizontally:", box_scale)
			State.Scalar:
				pass
	
func _physics_process(delta):
	scaling()
