extends CanvasLayer


signal new_game_pressed

func _on_NewGameButton_pressed():
	$Box.hide()
	emit_signal("new_game_pressed")
