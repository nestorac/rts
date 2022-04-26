extends KinematicBody

var hp = 3
var damaged = false
var velocity = Vector3.ZERO
onready var player = $"../Navigation/Warrior"
const SPEED = 100

onready var anim = get_node("AnimationPlayer2")

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
	velocity = global_transform.direction_to(player.global_transform.origin()) * SPEED
	velocity = move_and_slide(velocity)

func _process(delta):
	pass

func _on_Hurtbox_area_entered(area):
	if area.is_in_group("Weapon"):
		damaged = true
		
func apply_damage():
	hp -= 1
	damaged = false
