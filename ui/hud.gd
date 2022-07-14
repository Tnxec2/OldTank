extends CanvasLayer

signal bomb_pressed
signal shot_pressed
signal cannon_pressed
signal missile_pressed


func _on_VBoxContainer_bomb_pressed():
	emit_signal("bomb_pressed")

func _on_VBoxContainer_cannon_pressed():
	emit_signal("cannon_pressed")

func _on_VBoxContainer_missile_pressed():
	emit_signal("missile_pressed")

func _on_VBoxContainer_shot_pressed():
	emit_signal("shot_pressed")

func _on_Player_change_bomb_count(value: int):
	print(str(value))
	$Control/VBoxContainer/BombContainer/Background/Label.text = str(value)

func _on_Player_change_cannon_count(value: int):
	$Control/VBoxContainer/CannonContainer/Background/Label.text = str(value)

func _on_Player_change_missile_count(value: int):
	$Control/VBoxContainer/MissileContainer/Background/Label.text = str(value)


func _on_Player_health_changed(value: int):
	$Control/VBoxContainer/LifeContainer/Control/LifeIcon/Label.text = str(value)


func _on_Map_change_killed_enemys(value: int):
	$Control/VBoxContainer/EnemysContainer/Control/EnemysIcon/Label.text = str(value)
