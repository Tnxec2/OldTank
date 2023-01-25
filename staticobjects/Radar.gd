extends StaticBody2D

signal locate_player(status)
signal dead
signal clicked

onready var collisionShape = $CollisionShape2D
onready var detectRadiusCollider = $DetectRadius/CollisionShape2D
onready var sprite = $AnimatedSprite
onready var explosion = $Explosion

const ROTATE_SPEED = PI/24

var player = null

var healt = 10
var alive = true
var player_located = false

func _ready() -> void:
	detectRadiusCollider.disabled = true


func set_player(body):
	player = body


func _physics_process(delta):
	if alive && player_located:
		$AnimatedSprite.rotate(ROTATE_SPEED)


func take_damage(damage):
	healt -= damage
	if healt <= 0:
		explode()


func explode():
	collisionShape.disabled = true
	detectRadiusCollider.disabled = true
	alive = false
	sprite.hide()
	explosion.show()
	explosion.play()
	emit_signal("locate_player", false)
	emit_signal("dead")


func _on_Explosion_animation_finished():
	queue_free()
	
	
func _on_DetectRadius_body_entered(body):
	if body == player:
		player_located = true
		emit_signal("locate_player", true)


func _on_DetectRadius_body_exited(body):
	if body == player:
		player_located = false
		emit_signal("locate_player", false)


func _on_Radar_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton:
		emit_signal("clicked")


func _on_StartTimer_timeout() -> void:
	detectRadiusCollider.disabled = false
