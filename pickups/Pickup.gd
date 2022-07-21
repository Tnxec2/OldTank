extends Area2D

const PickupTypes = preload("res://pickups/PickupTypes.gd")

var amount = 0
var type = PickupTypes.Health

func _on_Pickup_body_entered(body):
	if body.is_in_group('trucks'):
		return
	if body.has_method('put_pickup'):
		body.put_pickup(type, amount)
	queue_free()


func _on_EraseTimer_timeout():
	queue_free()
