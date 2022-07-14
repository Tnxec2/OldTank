extends VBoxContainer


signal shot_pressed()
signal cannon_pressed()
signal missile_pressed()
signal bomb_pressed()

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _on_Shot_pressed():
	emit_signal("shot_pressed")

func _on_Cannon_pressed():
	emit_signal("cannon_pressed")

func _on_Missile_pressed():
	emit_signal("missile_pressed")

func _on_Bomb_pressed():
	emit_signal("bomb_pressed")
