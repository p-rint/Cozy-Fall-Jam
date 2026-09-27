extends Node3D

var dt : float

var mouseLock = false

@onready var cam : Camera3D = $Camera3D

@onready var player: CharacterBody3D = $".."

@onready var startPos = cam.position

var digOffset : Vector3 =  Vector3(0,2,3)
var digRotOffset : Vector3 =  Vector3(deg_to_rad(-20),0,0)

var camOffset : Vector3 =  Vector3(0,0,0)

var rotOffset : Vector3 = Vector3(0,0,0)
var startFOV = 80
var fovOffset = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Input.mouse_mode = (Input.MOUSE_MODE_CAPTURED)
	pass # Replace with function body.


func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion and not mouseLock:
		
		
		
		rotation.y -= event.relative.x * .001 #Left <-> Right
		
		if player.state == 0: #Moving state only
			rotation.x -= event.relative.y * .001 #Up <-> Down
		
		rotation.y = wrapf(rotation.y, -PI, PI)
		rotation.x = clampf(rotation.x,-PI/2,PI/2)
	
	if event is InputEventMouseButton and event.pressed:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		
	
	if event.is_action_pressed("Tab"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	if event.is_action_released("Tab"):
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

	
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	dt = delta
	
	cam.position = lerp(cam.position, startPos + camOffset, dt * 8)
	
	cam.fov = lerp(startFOV, startFOV + fovOffset, dt * 8)
	
	if player.state == 1: #digging only
		camOffset = digOffset
		rotOffset = digRotOffset
		rotation.x = lerp_angle(rotation.x, rotOffset.x, dt * 8)
	else:
		camOffset = Vector3.ZERO
		rotOffset = Vector3.ZERO
