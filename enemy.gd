extends CharacterBody2D

@export var player : CharacterBody2D
@export var stun_time = 1.5
var speed=Vector2(210,0)

var stunned = false

func _physics_process(delta):
	check_if_stunned()
	follow_player()
	move_and_slide()
	
func get_player_position():
	
	return player.position
	
func follow_player():
	print(position.distance_squared_to(player.position)/80)
	if stunned:
		velocity.x = move_toward(velocity.x, 0, 20 / (position.distance_to(player.position)/80))
		velocity.y = move_toward(velocity.y, 0, 20 / (position.distance_to(player.position)/80))
	else:
		var rotated_speed = speed.rotated(position.angle_to_point(player.position))
		velocity = rotated_speed

func check_if_stunned():
	if player.flashlight_state and player.check_if_in_light(self):
		$StunTimer.start(stun_time)
		stunned = true

func _on_stun_timer_timeout():
	stunned = false
