extends CharacterBody3D

var direction : Vector3
var input_dir : Vector2
var SPEED = 15.0
var DIGSPEED = 15.0
const JUMP_VELOCITY = 5

@onready var camPiv = $CamPivot
@onready var model = $Character
@onready var mesh: MeshInstance3D = $Character/MeshInstance3D

var dt : float
var targetRot = 0

var camForw : Vector3

enum states {MOVE, DIGGING}
var state = states.MOVE


func flatten(vector: Vector3) -> Vector3:
	return Vector3( vector.x, 0, vector.z)

func move() -> void:
	direction = flatten($CamPivot.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	model.rotation.y = lerp_angle(model.rotation.y, targetRot, dt * 12)
	if direction:
		velocity.x = lerp(velocity.x, direction.x * SPEED, dt * 8)
		velocity.z = lerp(velocity.z, direction.z * SPEED, dt * 8)
		targetRot = atan2(-direction.x, -direction.z)
	else:
		if is_on_floor():
			velocity = lerp(velocity, Vector3.ZERO + Vector3(0,velocity.y,0), 8 * dt)
	

func dig():
	print($CamPivot.basis.y)
	direction = ( ($CamPivot.basis.x * input_dir.x) + (-$CamPivot.basis.y * input_dir.y) ).normalized()
	model.rotation.y = 0
	model.rotation.z = lerp_angle(model.rotation.z, targetRot, dt * 12)
	
	if direction:
		velocity = lerp(velocity, direction * DIGSPEED, dt * 8)
		
		#targetRot = atan2(-direction.x, -direction.z)
	else:
		if is_on_floor():
			velocity = lerp(velocity, Vector3.ZERO + Vector3(0,velocity.y,0), 8 * dt)


func _physics_process(delta: float) -> void:
	dt = delta
	camForw = flatten($CamPivot.basis.z)
	runInputs()
	
	runCurState()
	
	move_and_slide()
	checkLife()
	
	
	
	

func stateMOVE():
	addGravity()
	move()


func stateDIG():
	dig()
	print("digggi")
	
func runCurState():
	if state == states.MOVE:
		stateMOVE()
	elif state == states.DIGGING:
		stateDIG()


func addGravity() -> void:
	if not is_on_floor():
		velocity += get_gravity() * dt
	
func jump() -> void:
	velocity.y = JUMP_VELOCITY



func runInputs() -> void:
	if Input.is_action_just_pressed("Jump") and is_on_floor():
		jump()

	if Input.is_action_just_pressed("Attack") and is_on_floor():
		pass
	
	if Input.is_action_just_pressed("Dig") and is_on_floor():
		if state == states.MOVE:
			state = states.DIGGING
		elif state == states.DIGGING:
			state = states.MOVE
	
	input_dir = Input.get_vector("Left", "Right", "Up", "Down")
	



func checkLife() -> void:
	if position.y < -15:
		get_tree().change_scene_to_file("res://main.tscn")
