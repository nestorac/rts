extends Node

onready var guerrero = get_node("Warrior")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func _input(event):
	if (event is InputEventMouseButton and event.pressed and event.button_index == 1):
		var camera = $Camera
		var mouse_pos = get_viewport().get_mouse_position()
		var from = camera.project_ray_origin(mouse_pos)
		var to = from + camera.project_ray_normal(mouse_pos)
		# Apply the position to whatever object you want
		guerrero.global_transform.origin = guerrero.global_transform.origin.linear_interpolate(to, 0.3)
