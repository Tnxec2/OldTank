extends Area2D

export (int) var speed
export (int) var damage
export (float) var steer_force = 0

var velocity = Vector2()
var acceleration = Vector2()
var target = null

var isEnemyBullet = false

func start(_position, _direction, _target=null):
	position = _position
	rotation = _direction.angle()
	velocity = _direction * speed
	target = _target
	init_missile()


func init_missile():
	pass

func seek():
	var desired = (target.global_position - global_position).normalized() * speed
	var steer = (desired - velocity).normalized() * steer_force
	return steer


func control(delta):
	pass


func _process(delta):
	control(delta)
	if target != null && is_instance_valid(target):
		acceleration += seek()
		velocity += acceleration * delta
		velocity = velocity.clamped(speed)
		rotation = velocity.angle()
	position += velocity * delta


func explode():
	release()
	set_process(false)
	velocity = Vector2.ZERO
	$Sprite.hide()
	$Explosion.show()
	$Explosion.play()


func release():
	pass

func _on_Bullet_body_entered(body):
	$CollisionShape2D.disabled = true
	#print("_on_Bullet_body_entered: ", body)
	position = body.global_position
	explode()
	if body.has_method('take_damage'):
		if isEnemyBullet:
			if body.is_in_group('trucks') || body.is_in_group('walls'):
				return
		body.take_damage(damage)


func take_damage(damage):
	queue_free()


func _on_Explosion_animation_finished():
	queue_free()


func _on_LifeTime_timeout():
	queue_free()


func _on_Bullet_area_entered(area):
	_on_Bullet_body_entered(area)
