extends Node2D
var game_ended = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$EndMessageLabel.hide()
	$AudioStreamPlayer2D.play()
	start_pattern(1, 3)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if game_over():
		change_scene()
	if $BossEnemy == null and not game_ended:
		end_game_message()
		game_ended = true
	pass
	
func start_pattern(pattern_num, time):
	if pattern_num == 1:
		$Tile0Timer.start(time)
		$Tile1Timer.start(time)
		$Tile2Timer.start(time)
	if pattern_num == 2:
		$Tile0Timer.start(time - 1)
		$Tile1Timer.start(time)
		$Tile2Timer.start(time + 2)
	if pattern_num == 3:
		$Tile0Timer.start(time + 2)
		$Tile1Timer.start(time - 2)
		$Tile2Timer.start(time)


func _on_tile_0_timer_timeout() -> void:
	$Tile0.hide()
	$Tile0.collision_enabled = false
	await get_tree().create_timer(0.5).timeout
	$Tile0.show()
	$Tile0.collision_enabled = true
	$Tile0Timer.start()
	pass # Replace with function body.
	


func _on_tile_1_timer_timeout() -> void:
	$Tile1.hide()
	$Tile1.collision_enabled = false
	
	await get_tree().create_timer(1).timeout
	$Tile1.show()
	$Tile1.collision_enabled = true
	$Tile1Timer.start()
	pass # Replace with function body.


func _on_tile_2_timer_timeout() -> void:
	$Tile2.hide()
	$Tile2.collision_enabled = false
	await get_tree().create_timer(1.5).timeout
	$Tile2.show()
	$Tile2.collision_enabled = true
	$Tile2Timer.start()
	
	pass # Replace with function body.

func game_over():
	if $Player.health <= 0:
		return true
	false

func end_game_message():
	$EndMessageLabel.show()
	$EndMessageLabel.text = "You win! Game over!"
	await get_tree().create_timer(3.5).timeout
	$EndMessageLabel.text = "Nothing else is here for you"
	await get_tree().create_timer(5).timeout
	$EndMessageLabel.text = "Are you still here?"
	await get_tree().create_timer(3.5).timeout
	$EndMessageLabel.text = "Fine then you leave me no choice"
	await get_tree().create_timer(3.5).timeout
	get_tree().quit()
	

func change_scene():
		get_tree().change_scene_to_file("res://main.tscn")
		Global.finish_scene_change()
