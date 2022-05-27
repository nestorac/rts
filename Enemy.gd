extends KinematicBody

var hp = 3
var damaged = false

var target

# State machine

enum {
	IDLE,
	CHASE,
	ATTACK
}

var state = IDLE
export(NodePath) onready var mesh = get_node(mesh) as MeshInstance
export(NodePath) onready var anim_player = get_node(anim_player) as AnimationPlayer

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
	match state:
		IDLE:
			change_color(Color(0,1,0))
			anim_player.play("Idle")
		CHASE:
			anim_player.play("Walk")
			change_color(Color(1,0,0))
			if path_index < path.size():
				var move_vector = path[path_index] - global_transform.origin
				
				if move_vector.length() < 1:
					path_index += 1
				else:
					look_at(target.transform.origin, Vector3.UP)
					move_and_slide(move_vector.normalized() * SPEED * delta, Vector3.UP)
		ATTACK:
			anim_player.play("Attack")
			change_color(Color(1,0,1))


func change_color(color:Color):
	var material = mesh.get_surface_material(0)
	material.albedo_color = color
	mesh.set_surface_material(0, material)

func move_to(target_pos):
	path = navigation.get_simple_path(global_transform.origin, target_pos)
	path_index = 0


func _on_Hurtbox_area_entered(area):
	if area.is_in_group("Weapon2"):
		damaged = true

		
func apply_damage():
	hp -= 1
	damaged = false


func _on_VisionBox_body_entered(body):
	if body.is_in_group("PlayerUnit"):
		target = body
		state = CHASE


func _on_Timer_timeout():
	if target:
		move_to(target.global_transform.origin)


func _on_AttackRange_body_entered(body):
	if body.is_in_group("PlayerUnit"):
		target = body
		state = ATTACK


func _on_AttackRange_body_exited(body):
	if body.is_in_group("PlayerUnit"):
		state = CHASE
