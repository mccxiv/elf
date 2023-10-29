extends CharacterBody3D

const SPEED = 2.0
const JUMP_VELOCITY = 2.5
const ACCELERATION = SPEED * 4 
const DECELERATION = SPEED * 3 
const MOUSE_SENSITIVITY = 0.0035
const BOB_FREQUENCY = 20.0
const BOB_AMPLITUDE = 0.03
@onready var neck := $neck
@onready var camera := $neck/Camera3D

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

# Variables for head bobbing.
var bob_timer = 0.0
var bob_offset = 0.0

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _unhandled_input(event: InputEvent):
	if event is InputEventMouseButton:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	elif event.is_action_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	elif Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		if event is InputEventMouseMotion:
			neck.rotate_y(-event.relative.x * MOUSE_SENSITIVITY)
			camera.rotate_x(-event.relative.y * MOUSE_SENSITIVITY)
			camera.rotation.x = clamp(
				camera.rotation.x, 
				deg_to_rad(-60),
				deg_to_rad(80)
			)

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Handle Jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector("left", "right", "forward", "back")
	var direction = (neck.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = move_toward(velocity.x, direction.x * SPEED, ACCELERATION * delta)
		velocity.z = move_toward(velocity.z, direction.z * SPEED, ACCELERATION * delta)
	else:
		velocity.x = move_toward(velocity.x, 0, DECELERATION * delta)
		velocity.z = move_toward(velocity.z, 0, DECELERATION * delta)

	# Handle head bobbing.
	if direction and is_on_floor():
		bob_timer += delta * BOB_FREQUENCY
		bob_offset = sin(bob_timer) * BOB_AMPLITUDE
	else:
		bob_timer = 0.0
		bob_offset = 0.0

	# Apply head bobbing to camera.
	camera.transform.origin.y = bob_offset

	move_and_slide()
