extends CharacterBody2D

@export var SPEED = 190

var flashlight_state = false
@onready var light_1 = $Body_1/PointLight2D
@onready var light_2 = $Body_2/PointLight2D

var flashlight_cooling_state = false
var flashlight_heat = 0
var flashlight_heat_limit = 30
@export var flashlight_heating_rate = 0.05
@export var flashlight_cooling_rate = 0.1
@export var flashlight_heat_stun_time = 3
@export var flashlight_heat_trun_off_time = 0.1

var control = true

func _ready():
	Signals.player_hit.connect(take_control)
	Signals.control_back.connect(return_control)

func take_control():
	control = false

func return_control():
	control = true

func _physics_process(delta):
	if control:
		if Input.is_action_pressed("ui_accept") and $Flashlight/StunTimer.is_stopped() and $Flashlight/TurnOffTimer.is_stopped():
			flashlight_cooling_state = false
			flashlight_state = true
		elif $Flashlight/StunTimer.is_stopped() and $Flashlight/TurnOffTimer.is_stopped():
			$Flashlight/TurnOffTimer.start(flashlight_heat_trun_off_time)
			flashlight_state = false
		else:
			flashlight_state = false

	if control:
		follow_cursor()

	flashlight_switch(flashlight_state)
	flashlight_heating(flashlight_state)
	flashlight_cooling(flashlight_cooling_state)
	flashlight_effect()

	if control:
		var direction = Input.get_vector("move_left", "move_right","move_up", "move_down")
		if direction:
			velocity = direction * SPEED
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
			velocity.y = move_toward(velocity.y, 0 ,SPEED)
	move_and_slide()

func follow_cursor():
	rotation = position.angle_to_point(get_global_mouse_position()) + -PI/2

func flashlight_switch( state : bool):
	light_1.enabled = state
	light_2.enabled = state

func check_if_in_light(body):
	if $Body_1/LightArea.overlaps_body(body):
		return true
	elif $Body_2/LightArea.overlaps_body(body):
		return true
	else:
		return false

func flashlight_effect():
	$Body_1/Flashlight/Heat.energy = remap(flashlight_heat,0, 20, 0, 16)
	$Body_2/Flashlight/Heat.energy = remap(flashlight_heat,0, 20, 0, 16)

func flashlight_heating( state : bool ):
	if flashlight_state and $Flashlight/HeatingTickTimer.is_stopped() and flashlight_heat < flashlight_heat_limit:
		$Flashlight/HeatingTickTimer.start(flashlight_heating_rate)
	elif flashlight_heat >= flashlight_heat_limit and $Flashlight/StunTimer.is_stopped():
		flashlight_cooling_state = true
		$Flashlight/StunTimer.start(flashlight_heat_stun_time)

func _on_stun_timer_timeout():
	flashlight_cooling_state = true

func _on_turn_off_timer_timeout():
	flashlight_cooling_state = true

func _on_heating_tick_timer_timeout():
	flashlight_heat += 1

func flashlight_cooling( state : bool ):
	if state and $Flashlight/CoolingTickTimer.is_stopped() and flashlight_heat > 0:
		$Flashlight/CoolingTickTimer.start(flashlight_cooling_rate)

func _on_cooling_tick_timer_timeout():
	flashlight_heat -= 1
