extends Position3D

onready var arrow = $"Arrow"

func shoot_arrow():
#	arrow.shoot()
	var arrows = get_children()
	
	for arrow in arrows:
		if not arrow.is_shot:
			arrow.shoot()
			print(arrow.name)
			return
	
