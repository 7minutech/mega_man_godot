extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$AudioStreamPlayer2D.play()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	change_scene()

	pass


func _on_transition_area_body_entered(body: Node2D) -> void:
	if body.has_method("player"):
		Global.transition_scene = true
		pass
	pass # Replace with function body.


func _on_transition_area_body_exited(body: Node2D) -> void:
	if body.has_method("Player"):
		Global.transition_scene = false
		pass
	pass # Replace with function body.

func change_scene():
	if Global.transition_scene:
		if Global.current_scene == "world":
			get_tree().change_scene_to_file("res://boss_room.tscn")
			Global.finish_scene_change()
