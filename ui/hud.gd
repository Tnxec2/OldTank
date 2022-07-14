extends CanvasLayer

signal bomb_pressed
signal shot_pressed
signal cannon_pressed
signal missile_pressed

var button_selected = preload("res://assets/button_square_9_selected.png")
var button_normal = preload("res://assets/button_square_9.png")

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


func _on_Map_change_bullet_type(bulletType):
	$Control/VBoxContainer/ShotContainer/Background.texture = button_normal
	$Control/VBoxContainer/CannonContainer/Background.texture = button_normal
	$Control/VBoxContainer/MissileContainer/Background.texture = button_normal
	if bulletType == 2:
		$Control/VBoxContainer/MissileContainer/Background.texture = button_selected
	elif bulletType == 1:
		$Control/VBoxContainer/CannonContainer/Background.texture = button_selected
	else:
		$Control/VBoxContainer/ShotContainer/Background.texture = button_selected
