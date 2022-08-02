extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	VisualServer.set_default_clear_color(Color(1,1,1)) # set background to white
	$GameOver/Box.hide()
	G.player = $Map/Player
	G.located_forts = []


func _on_Map_game_over(win: bool):
	if win:
		$GameOver/Box/VBoxContainer/GameOver/Label.text = "Win!"
	else:
		$GameOver/Box/VBoxContainer/GameOver/Label.text = "Game over"
	$GameOver/Box.show()


func _on_GameOver_new_game_pressed():
	G.located_forts = []
	get_tree().change_scene("res://StartScreen.tscn")

