extends CharacterBody2D

@export var player : CharacterBody2D
var speed=Vector2(100,0)


func _physics_process(delta):

	follow_player()
	move_and_slide()
	
func get_player_position():
	
	return player.position
	
func follow_player():
	if player.flashlight_state:
		velocity = Vector2.ZERO
	else:
		var rotated_speed = speed.rotated(position.angle_to_point(player.position))
		velocity = rotated_speed


