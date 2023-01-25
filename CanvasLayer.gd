extends CanvasLayer

signal quit

func _ready() -> void:
	pass


func unpause():
	$Box.hide()
	get_tree().paused = false


func _on_QuityButton_pressed() -> void:
	unpause()
	emit_signal("quit")


func _on_PlayButton_pressed() -> void:
	unpause()
