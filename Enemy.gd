extends KinematicBody

var hp = 3
var damaged = false

var target

onready var anim = get_node("AnimationPlayer2")

# For pathfinding
var path = []
var path_index = 0
const SPEED = 250
onready var navigation = get_parent()

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _physics_process(delta):
#	cuando hp llega a cero, el enemigo muere y ganamos la partida
	if hp <= 0:
#		el enemigo muere
		queue_free()
	if damaged == true:
		apply_damage()
		anim.play("Damage")
		
	if path_index < path.size():
		var move_vector = path[path_index] - global_transform.origin
		
		if move_vector.length() < 1:
			path_index += 1
		else:
			move_and_slide(move_vector.normalized() * SPEED * delta, Vector3.UP)


func move_to(target_pos):
	path = navigation.get_simple_path(global_transform.origin, target_pos)
	path_index = 0


func _on_Hurtbox_area_entered(area):
	if area.is_in_group("Weapon"):
		damaged = true

		
func apply_damage():
	hp -= 1
	damaged = false


func _on_VisionBox_body_entered(body):
	if body.is_in_group("PlayerUnit"):
		target = body


func _on_Timer_timeout():
	if target:
		move_to(target.global_transform.origin)
