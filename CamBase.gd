extends Spatial

const MOVE_MARGIN = 20
const MOVE_SPEED = 30
const RAY_LENGHT = 1000

# Rotación
export var rot_speed = 30
var last_mouse_position = Vector2()
var is_rotating = false

# Variables del zoom
export (int) var max_zoom = 90
export (int) var min_zoom = -10
export (float) var zoom_speed = 50
var zoom_direction = 0
onready var camera = $Elevation/Camera

# Variables de la selecciṕón
var selected_units = []
var start_selection_position = Vector2()
onready var selection_box = $SelectionBox

func _process(delta):
	var mouse_position = get_viewport().get_mouse_position()
	calc_move(delta, mouse_position)
	mouse_rotate(delta)
	zoom(delta)
	if Input.is_action_pressed("right_click"):
		move_selected_units(mouse_position)

	if Input.is_action_just_pressed("command"):
		selection_box.start_selection_position = mouse_position
		start_selection_position = mouse_position
	if Input.is_action_pressed("command"):
		selection_box.mouse_position = mouse_position
		selection_box.is_visible = true
	else:
		selection_box.is_visible = false
	if Input.is_action_just_released("command"):
		select_units(mouse_position)

func _unhandled_input(event):
	# See if we are rotating the camera.
	if event.is_action_pressed("center_click"):
		is_rotating = true
		last_mouse_position = get_viewport().get_mouse_position()
	if event.is_action_released("center_click"):
		is_rotating = false
	if event.is_action_pressed("zoom_in"):
		zoom_direction = -1
	if event.is_action_pressed("zoom_out"):
		zoom_direction = 1

func zoom(delta):
	# Calcular nuevo zoom
	var new_zoom = clamp(camera.translation.z + zoom_speed * zoom_direction * delta, min_zoom, max_zoom)
	camera.translation.z = new_zoom
	
	# Delimitar los valores del zoom
	# Dejar de mover el zoom cuando no haga nada el jugador
	zoom_direction = 0

func mouse_rotate(delta):
	if not is_rotating:
		return
		
	# Calcular el desplazamiento del ratón
	var displacement = get_mouse_displ()
	
	# Usar el desplazamiento para rotar la cḿámara
	rotate_horizontal(delta, displacement.x)

func get_mouse_displ():
	var current_mouse_position = get_viewport().get_mouse_position()
	var displacement = current_mouse_position - last_mouse_position
	
	last_mouse_position = current_mouse_position
	return displacement

func rotate_horizontal(delta, displacement_x):
	rotation_degrees.y += displacement_x * delta * rot_speed
	

func calc_move(delta, m_pos):
	if is_rotating:
		return
	
	var viewport_size = get_viewport().size
	var move_vector = Vector3()
	if m_pos.x < MOVE_MARGIN:
		move_vector -= transform.basis.x
	if m_pos.y < MOVE_MARGIN:
		move_vector -= transform.basis.z
	if m_pos.x > ( viewport_size.x - MOVE_MARGIN ):
		move_vector += transform.basis.x
	if m_pos.y > ( viewport_size.y - MOVE_MARGIN ):
		move_vector += transform.basis.z
	
	global_translate(move_vector * MOVE_SPEED * delta)

func ray_from_mouse (mouse_position, collision_mask):
	var ray_start = camera.project_ray_origin(mouse_position)
	var ray_end = ray_start + camera.project_ray_normal(mouse_position) * RAY_LENGHT
	var space_state = get_world().direct_space_state
	
	return space_state.intersect_ray(ray_start, ray_end, [], collision_mask)

func get_unit_under_mouse(mouse_position):
	var result = ray_from_mouse(mouse_position, 2)
	if result:
		print(result.collider)
		return result.collider
		
func get_unit_under_box(top_left, bottom_right):
	if top_left.x > bottom_right.x:
		var temp = top_left.x
		top_left.x = bottom_right.x
		bottom_right.x = temp
	if top_left.y > bottom_right.y:
		var temp = top_left.y
		top_left.y = bottom_right.y
		bottom_right.y = temp
		
	var box = Rect2(top_left, bottom_right - top_left)
	var box_selected_units = []
	
	for unit in get_tree().get_nodes_in_group("Units"):
		if box.has_point(camera.unproject_position(unit.global_transform.origin)):
			box_selected_units.append(unit)
	print (box_selected_units)
	return box_selected_units

func move_selected_units(mouse_position):
	var result = ray_from_mouse(mouse_position, 1)
	
	if result:
		for unit in selected_units:
			unit.move_to(result.position)

func select_units(mouse_position):
	var new_selected_units = []
	if mouse_position.distance_squared_to(start_selection_position) < 16:
		var unit = get_unit_under_mouse(start_selection_position)
		if unit != null:
			new_selected_units.append(unit)
	else:
		new_selected_units = get_unit_under_box(start_selection_position, mouse_position)
	if new_selected_units.size() != 0:
		for unit in selected_units:
			unit.deselect()
		for unit in new_selected_units:
			unit.select()
		selected_units = new_selected_units
