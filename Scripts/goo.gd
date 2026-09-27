extends Area3D

@onready var health = 3

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	var targetSize = .4 + (health * .4)
	
	scale = scale.lerp(Vector3(targetSize,targetSize,targetSize), delta * 10)
	
	if health <= 0:
		queue_free()

func damage(dmg : float):
	health -= dmg
	scale /= 2.0
	print("ow")
	get_parent().curGoo -= dmg
