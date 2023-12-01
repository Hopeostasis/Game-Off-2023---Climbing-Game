extends Area2D
class_name EndGoal


var activated = false


func activate():
	activated = true


func _on_body_entered(body):
	if body is Player && !activated:
		activate()
		print("Checkpoint Reached")
