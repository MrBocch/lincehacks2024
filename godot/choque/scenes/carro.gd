extends CharacterBody3D

const MASA = 100
const SPEED = 10
const JUMP_VELOCITY = 4.5
const TURN_RADIUS = 2.5

@export_group("Dato de usuario")
@export var nombre = ""
@export var localizacion = ""
@export var id:int 

@onready var http_request = $HTTPRequest
@onready var url = "http://127.0.0.1:xxxx"


# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func _ready():
	pass

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector("", "", "ui_up", "ui_down")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:

		velocity.x = direction.x * SPEED 
		velocity.z = direction.z * SPEED 
		if Input.is_action_pressed("ui_left"):
			self.rotation.y += TURN_RADIUS * delta
		elif Input.is_action_pressed("ui_right"):
			self.rotation.y -= TURN_RADIUS * delta

	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	
	move_and_slide()


func _on_area_3d_area_entered(trucka):
	# tipos de choque 
	# 
	trucka.get_parent().crashed = true
	

	# send this to ambulance, so it can go


	
	# hacer peticion
	var data = {
		"nombre": nombre,
		"localizacion": localizacion,
		"id": id
	}
	
	var data_send = JSON.stringify(data)
	var headers = ["Content-Type: application/json"]
	http_request.request(url, headers, HTTPClient.METHOD_POST, data_send)


# resultado de peticion
func _on_http_request_request_completed(result, response_code, headers, body):
	print(response_code)
	print(body.get_string_from_utf8())
	
