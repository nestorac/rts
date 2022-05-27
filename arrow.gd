extends WeaponClass

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

export var speed = 15
var is_shot = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
	
func _physics_process(delta):
	if is_shot:
		var forward_vector = global_transform.basis.z
		global_translate(forward_vector * speed * delta)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _on_Timer_timeout():
	is_shot = false
	visible = false
	transform.origin = Vector3(0,0,0)
	$"Timer".stop()
	

func shoot():
	transform.origin = Vector3(0,0,0)
	is_shot = true
	visible = true
	$"Timer".start()
