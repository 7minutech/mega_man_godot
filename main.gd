extends Node2D
var restart = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$AudioStreamPlayer2D.play()
	hide_restart_ui()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	change_scene()
	restart_game()
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

func game_over():
	if $Player.health <= 0: return true
	if Global.boss_died: return true
	false

func restart_game():
	if game_over():
		$Player.position = $ResetMarker.position
		show_restart_ui()
		if restart:
			hide_restart_ui()
			Global.player_health = 5
			Global.player_score = 0
			restart = false
			get_tree().change_scene_to_file("res://main.tscn")
			Global.finish_scene_change()
			if not is_inside_tree():
				return
			get_tree().reload_current_scene()
			


func hide_restart_ui():
	$RestartLabel.hide()
	$YesButton.hide()
	$NoButton.hide()

func show_restart_ui():
	if $Player.health<= 0:
		$RestartLabel.text = "Try again?"
	$RestartLabel.show()
	$YesButton.show()
	$NoButton.show()


func _on_yes_button_pressed() -> void:
	restart = true
	pass # Replace with function body.


func _on_no_button_pressed() -> void:
	get_tree().quit()
	pass # Replace with function body.
