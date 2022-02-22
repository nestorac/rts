extends Spatial

var ray_origin = Vector3()
var ray_target = Vector3()

onready var camera = $"Warrior/Camera"
onready var warrior = $"Warrior"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass
	
func _physics_process(delta):
	var mouse_position = get_viewport().get_mouse_position()
#	print(mouse_position)
	ray_origin = camera.project_ray_origin(mouse_position)
	ray_target = ray_origin + camera.project_ray_normal(mouse_position) * 1000

	var space_state = get_world().direct_space_state
	var intersect = space_state.intersect_ray(ray_origin, ray_target)
#	print(intersect)
	if not intersect.empty():
		var pos = intersect.position
		var look_at_horizontal = Vector3(pos.x, warrior.translation.y, pos.z)
		warrior.look_at(look_at_horizontal, Vector3.UP)
