extends StaticBody2D

signal clicked()

var health

func _ready():
	health = 40

func take_damage(damage: int):
	health -= damage
	if health <= 0:
		queue_free()

func _on_Tree_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		emit_signal("clicked")
