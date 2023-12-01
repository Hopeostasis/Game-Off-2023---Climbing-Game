extends Control

@onready var main = $"../../"

func _on_resume_pressed():
	main._pause_menu()


func _on_restart_pressed():
	SaveManagement.respawn_player()


func _on_quit_pressed():
	get_tree().quit()
