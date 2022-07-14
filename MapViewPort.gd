extends Viewport


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	$Map/StartPosition.position = Vector2(size[0]/2,size[1]/2)
	

