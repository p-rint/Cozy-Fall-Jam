extends Node3D

const TREE = preload("uid://upbc0qhefa1d")



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func spawnTree():
	var new : Node3D = TREE.instantiate()
	new.position = Vector3(randf_range(-20,20), 0, randf_range(-20,20))
	add_child(new)


func _on_tree_spawn_time_timeout() -> void:
	
	if get_children().size() < 5:
		spawnTree()
		print("y")
