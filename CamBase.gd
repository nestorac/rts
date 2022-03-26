extends Spatial

const MOVE_MARGIN = 20
const MOVE_SPEED = 30


func _process(delta):
	var mouse_position = get_viewport().get_mouse_position()
	calc_move(delta, mouse_position)


func calc_move(delta, m_pos):
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
