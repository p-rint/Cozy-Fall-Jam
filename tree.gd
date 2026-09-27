extends Node3D

const GOO = preload("uid://bb2e3wu7cn63i")

var totalGoo = 9

var curGoo = 9

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	spawnGoo()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	#$MeshInstance3D.set_instance_shader_parameter("i", (9-curGoo)/9)
	#$MeshInstance3D/MeshInstance3D2.get_surface_override_material(0).set_shader_parameter("i", (9-curGoo)/9)
	if curGoo <= 0:
		queue_free()
	
	
func spawnGoo():
	for i in 3:
		var new = GOO.instantiate()
		new.position = Vector3(randi_range(-5,5), -3, randi_range(-5,5))
		add_child(new)
		
	#curGoo = totalGoo
	#print(totalGoo)
