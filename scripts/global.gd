extends Node

var player_current_atk = false

var current_scene = "world"
var transition_scene = false 

var player_exit_clifside_posx = 0
var player_exit_clifside_posy = 0
var player_start_posx = 0
var player_start_posy = 0

func finish_scene_change():
	if transition_scene:
		transition_scene = false 
		if current_scene == "world":
			current_scene = "boss_room"
