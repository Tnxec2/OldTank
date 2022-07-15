extends StaticBody2D

var health

func _ready():
	health = 100

func take_damage(damage: int):
	health -= damage
	if health <= 0:
		queue_free()
