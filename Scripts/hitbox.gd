extends Area3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_area_entered(area: Area3D) -> void:
	if area.has_method("damage"):
		area.damage(1)

func on():
	monitoring = true
	$Timer.start(.1)

func _on_timer_timeout() -> void:
	monitoring = false
