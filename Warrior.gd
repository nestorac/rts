extends KinematicBody

var gravity = 1
var velocity = Vector3.ZERO
var mouse_position: Vector3
var arrow_resource = preload("res://arrow.tscn")

# Stats
var health = 3
var attack = 2

# For pathfinding
var path = []
var path_index = 0
const SPEED = 500
onready var navigation = get_parent()

export var move_factor = 0.3
onready var anim = get_node("AnimationPlayer")
onready var hand_position = $"Arm/HandPosition"
onready var selection_ring = $"SelectionRing"

onready var unit_stats_ui = $"UnitStatsUI"
onready var health_label = $"UnitStatsUI/BackgroundRect/VBoxContainer/HealthLabel"
onready var attack_label = $"UnitStatsUI/BackgroundRect/VBoxContainer/AttackLabel"
onready var speed_label = $"UnitStatsUI/BackgroundRect/VBoxContainer/SpeedLabel"

# Called when the node enters the scene tree for the first time.
func _ready():
	health_label.text = "health: " + str(health)
	attack_label.text = "attack: " + str(attack)
	speed_label.text = "speed: " + str(SPEED)

func _physics_process(delta):
	if path_index < path.size():
		var move_vector = path[path_index] - global_transform.origin
		
		if move_vector.length() < 1:
			path_index += 1
		else:
			look_at(path[path_index],Vector3.UP)
			move_and_slide(move_vector.normalized() * SPEED * delta, Vector3.UP)

	if Input.is_action_just_pressed("ui_accept"):
		anim.play("Arrow")

func shoot_arrow():
	var arrow = arrow_resource.instance()
	
	get_tree().root.add_child(arrow)
	arrow.global_transform.origin = hand_position.global_transform.origin
	arrow.rotation_degrees = rotation_degrees

func move_to(target_pos):
	path = navigation.get_simple_path(global_transform.origin, target_pos)
	path_index = 0
	
func select():
	selection_ring.show()
	unit_stats_ui.show()

func deselect():
	selection_ring.hide()
	unit_stats_ui.hide()

func get_damage(damage):	
	health -= damage
	health_label.text = "health: " + str(health)
	if health <= 0:
		visible = false

func _on_HurtBox_area_entered(area):
	if area.is_in_group("Weapon"):
		get_damage(area.Damage)
		print("Damage: ", area.Damage)
