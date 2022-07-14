extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	VisualServer.set_default_clear_color(Color(1,1,1)) # set background to white
	$GameOver/Box.hide()
	
func _on_Map_game_over():
	$GameOver/Box.show()


func _on_GameOver_new_game_pressed():
	get_tree().reload_current_scene()
