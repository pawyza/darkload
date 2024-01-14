extends CharacterBody2D

@export var SPEED = 210

var flashlight_state = false
@onready var light_1 = $Body_1/PointLight2D
@onready var light_2 = $Body_2/PointLight2D
@onready var light_3 = $Body_3/PointLight2D

func _physics_process(delta):
	
	if Input.is_action_pressed("ui_accept"):
		flashlight_state = true
	else:
		flashlight_state = false

	flashlight_switch(flashlight_state)

	var direction = Input.get_vector("ui_left", "ui_right","ui_up", "ui_down")
	if direction:
		velocity = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.y = move_toward(velocity.y, 0 ,SPEED)
	move_and_slide()

func flashlight_switch( state : bool):
	light_1.enabled = state
	light_2.enabled = state
	light_3.enabled = state
