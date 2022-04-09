extends Spatial

const MOVE_MARGIN = 20
const MOVE_SPEED = 30

# Rotación
export var rot_speed = 30
var last_mouse_position = Vector2()
var is_rotating = false

func _process(delta):
	var mouse_position = get_viewport().get_mouse_position()
	calc_move(delta, mouse_position)
	mouse_rotate(delta)
	
func _unhandled_input(event):
	# See if we are rotating the camera.
	if event.is_action_pressed("center_click"):
		is_rotating = true
		last_mouse_position = get_viewport().get_mouse_position()
	if event.is_action_released("center_click"):
		is_rotating = false

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
		move_vector.x -= 1
	if m_pos.y < MOVE_MARGIN:
		move_vector.z -= 1
	if m_pos.x > ( viewport_size.x - MOVE_MARGIN ):
		move_vector.x += 1
	if m_pos.y > ( viewport_size.y - MOVE_MARGIN ):
		move_vector.z += 1
	
	global_translate(move_vector * MOVE_SPEED * delta)
