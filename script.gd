extends Node

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func _input(event):
	if (event is InputEventMouseButton and event.pressed and event.button_index == 1):
		var camera = $Camera
		var mouse_pos = get_viewport().get_mouse_position()
		var from = camera.project_ray_origin(mouse_pos)
		var to = from + camera.camera_project_ray_normal(mouse_pos) * camera.distance_from_camera
		# Apply the position to whatever object you want
		get_node("Warrior").global_transform.origin = to
