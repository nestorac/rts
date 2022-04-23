extends KinematicBody

var gravity = 1
var velocity = Vector3.ZERO
var mouse_position: Vector3
var arrow_resource = preload("res://arrow.tscn")

# For pathfinding
var path = []
var path_index = 0
const SPEED = 1000
onready var navigation = get_parent()

export var move_factor = 0.3
onready var anim = get_node("AnimationPlayer")
onready var hand_position = $"Arm/HandPosition"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _physics_process(delta):
	
	if path_index < path.size():
		var move_vector = path[path_index] - global_transform.origin
		
		if move_vector.length() < 1:
			path_index += 1
		else:
			move_and_slide(move_vector.normalized() * SPEED * delta, Vector3.UP)

	if Input.is_action_just_pressed("right_click"):
		anim.play("Arrow")

func shoot_arrow():
	var arrow = arrow_resource.instance()
	
	get_tree().root.add_child(arrow)
	arrow.global_transform.origin = hand_position.global_transform.origin
	arrow.rotation_degrees = rotation_degrees

func move_to(target_pos):
	path = navigation.get_simple_path(global_transform.origin, target_pos)
	path_index = 0
	
