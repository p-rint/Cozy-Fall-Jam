extends CharacterBody3D

var direction : Vector3
var input_dir : Vector2
var yInpDir : float
var SPEED = 15.0
var DIGSPEED = 15.0
var YDIGSPEED = 13.0
const JUMP_VELOCITY = 5

@onready var camPiv = $CamPivot
@onready var model = $Character
@onready var mesh: MeshInstance3D = $Character/MeshInstance3D

var dt : float
var targetRot = 0

var camForw : Vector3

enum states {MOVE, DIGGING}

var state = states.MOVE

var isDropping = false

@onready var drillcast: RayCast3D = $DrillRayCast

@onready var dig_debounce: Timer = $Timers/DigDebounce


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
	
	direction = flatten($CamPivot.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	model.rotation.y = lerp_angle(model.rotation.y, targetRot, dt * 12)
	
	if direction:
		velocity = lerp(velocity, direction * DIGSPEED, dt * 8)
		
		targetRot = atan2(-direction.x, -direction.z)
	else:	
		velocity = lerp(velocity, Vector3.ZERO, 5 * dt)
	
	velocity.y = lerp(velocity.y, yInpDir * YDIGSPEED, 3 * dt)
		

func _physics_process(delta: float) -> void:
	dt = delta
	camForw = flatten($CamPivot.basis.z)
	runInputs()
	
	runCurState()
	
	move_and_slide()
	checkLife()
	

	

func stateMOVE():
	addGravity()
	
	drillcast.hit_back_faces = true
	drillcast.hit_from_inside = false
	collision_layer = 1
	collision_mask = 1
	
	drillcast.target_position.y = -1.5
	
	move()


func stateDIG():
	dig()
	drillcast.hit_back_faces = false
	drillcast.hit_from_inside = true
	drillcast.target_position = velocity.normalized()
	#print(drillcast.target_position)
	
	collision_layer = 2
	collision_mask = 2
	
	if drillcast.is_colliding() and dig_debounce.is_stopped():
		print(drillcast.get_collider())
		var toPoint = position - drillcast.get_collision_point()
		position += -drillcast.get_collision_normal() * 3
		velocity = -toPoint.normalized() * 10
		print("LEave!!")
		state = states.MOVE
		
		
	
	
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
	
	if Input.is_action_pressed("Dig") or Input.is_action_pressed("Shift"):
		drop()
	else:
		isDropping = false
		
	
	input_dir = Input.get_vector("Left", "Right", "Up", "Down")
	yInpDir = Input.get_axis("Shift", "Jump")


func drop():
	if state == states.MOVE:
		
		if drillcast.is_colliding():
			
			var toPoint = position - drillcast.get_collision_point()
			velocity = -toPoint.normalized() * 40
			
			state = states.DIGGING
			isDropping = false
			print("Start digging!")
			dig_debounce.start(.3)
		else:
			isDropping = true
			velocity.y = -10
	else:
		isDropping = false

func checkLife() -> void:
	if position.y < -15:
		get_tree().change_scene_to_file("res://main.tscn")
