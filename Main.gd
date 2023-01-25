extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	VisualServer.set_default_clear_color(Color(1,1,1)) # set background to white
	$GameOver/Box.hide()
	$Paused/Box.hide()
	G.player = $Map/Player
	G.located_forts = []


func _unhandled_input(event: InputEvent) -> void:
	if event.is_pressed():
		prints("_unhandled_input")


func _on_Map_game_over(win: bool):
	if win:
		$GameOver/Box/VBoxContainer/GameOver/Label.text = "Win!"
	else:
		$GameOver/Box/VBoxContainer/GameOver/Label.text = "Game over"
	$GameOver/Box.show()


func new_game():
	G.located_forts = []
	get_tree().change_scene("res://StartScreen.tscn")

func _on_GameOver_new_game_pressed():
	new_game()


func _on_HUD_pause_pressed() -> void:
	G.located_forts = []
	get_tree().paused = true
	$Paused/Box.show()


func _on_Paused_quit() -> void:
	new_game()
