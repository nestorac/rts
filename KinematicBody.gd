extends KinematicBody

var gravity = 0.1
var velocity = Vector3.ZERO

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _physics_process(delta):
	velocity.y -= gravity
	velocity = move_and_slide(velocity,Vector3.UP)
