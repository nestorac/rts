extends KinematicBody

var gravity = 0.1
var velocity = Vector3.ZERO
var mouse_position: Vector3
export var move_factor = 0.3

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _physics_process(delta):
	if not is_on_floor():
		velocity.y -= gravity
	velocity = move_and_slide(velocity,Vector3.UP)
	if mouse_position:
		translation = translation.move_toward(mouse_position, move_factor)
	print(mouse_position)
