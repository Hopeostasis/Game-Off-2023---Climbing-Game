extends Node2D
class_name Checkpoint


@export var spawnpoint = false

var activated = false


func activate():
	SaveManagement.current_checkpoint = self
	activated = true

func _on_checkpoint_area_body_entered(body):
	if body is Player && !activated:
		activate()
		print("Checkpoint Reached")
