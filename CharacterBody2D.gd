extends CharacterBody2D
class_name Player


@export var jump_buffer_time = 1
@export var coyote_time = 0.1

@export var speed = 200
var push_force = 12
var acceleration = 800
@export var friction = 1600

@export var jump_height : float
@export var jump_time_to_peak : float
@export var jump_time_to_descent : float

@onready var jump_velocity : float = -((2.0 * jump_height) / jump_time_to_peak)
@onready var jump_gravity : float = -((-2.0 * jump_height) / (jump_time_to_peak * jump_time_to_peak))
@onready var fall_gravity : float = -((-2.5 * jump_height) / (jump_time_to_descent * jump_time_to_descent))
@onready var landing_sound = $"../Landing Sound"

var win = false
var can_move = true

var jump_buffer_timer = 0.0
var coyote_timer = 0.0
var jumping= false

var onGround = true

func enter() -> void:
	enter()
	jump_buffer_timer = 0
	coyote_timer = coyote_time
	
#func input(event: InputEvent) -> CharacterBody2D:
	if Input.is_action_just_pressed("jump"):
		if coyote_timer >= 0:
			jump()
		jump_buffer_timer = jump_buffer_time
	#return null
	
func process(delta: float):
	jump_buffer_timer -= delta
	coyote_timer -= delta
	return null
	
func get_gravity():
	return jump_gravity if velocity.y < 0.0 else fall_gravity
	
func jump():
	jumping = true
	velocity.y = jump_velocity
	
func _landing():
	landing_sound.play()
	pass
	
func movement(delta):
	if can_move:
		var input_direction = Input.get_axis("left", "right")
		if input_direction != 0:
			var target_velocity = speed * input_direction
			var current_speed = velocity.move_toward(Vector2(target_velocity, 0), acceleration * delta)
			velocity = Vector2(current_speed.x, velocity.y)
		elif is_on_floor():
			velocity = velocity.move_toward(Vector2.ZERO, friction * delta)
		if Input.is_action_just_pressed("jump") and is_on_floor():
			jump()
		if is_on_floor() :
			if not onGround:
				_landing()
				onGround = true
		else:
			onGround = false
		
		if velocity.x != 0:
			$AnimatedSprite2D.play("run")
		else:
			$AnimatedSprite2D.play("default")
		if velocity.x < 0:
			get_node("AnimatedSprite2D").set_flip_h(true)
		elif velocity.x > 0:
			get_node("AnimatedSprite2D").set_flip_h(false)
func crouch():
	pass
		

		
#velocity = move_and_slide(velocity)
func _physics_process(delta):
	velocity.y += get_gravity() * delta
	movement(delta)
	move_and_slide()
	for i in get_slide_collision_count():
		var c = get_slide_collision(i)
		if c.get_collider() is RigidBody2D:
			c.get_collider().apply_impulse(-c.get_normal() * push_force)
		



func _on_area_2d_body_entered(body):
	print("Win!")
	if !win:
		velocity = Vector2(0,0)
		can_move = false
		$AnimatedSprite2D.stop()
		$AnimationPlayer.play("Ending 1")
		win = true
