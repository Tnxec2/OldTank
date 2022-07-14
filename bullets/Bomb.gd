extends Area2D

export (int) var damage

var onFire = false

# Called when the node enters the scene tree for the first time.
func _ready():
	$Explosion.hide()
	$StartTimer.start()
	
func explode():
	$Sprite.hide()
	$Explosion.show()
	$Explosion.play("smoke")
	
func take_damage():
	explode()

func _on_Bomb_body_entered(body):
	if onFire:
		explode()
		print("_on_Bomb_body_entered: ", body)
		if body.has_method('take_damage'):
			body.take_damage(damage)

func _on_StartTimer_timeout():
	onFire = true

func _on_Explosion_animation_finished():
	queue_free()

