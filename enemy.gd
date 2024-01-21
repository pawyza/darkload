extends CharacterBody2D

@export var player : CharacterBody2D
@export var stun_time = 1.5
@export var movement_speed = 350
@onready var navigation_agent: NavigationAgent2D = $NavigationAgent2D

var activated = false
@export var spawn_points_node : Node2D

var stunned = false
var chasing = true

func _ready():
	$AnimationPlayer.play("RESET")
	navigation_agent.path_desired_distance = 4.0
	navigation_agent.target_desired_distance = 4.0
	call_deferred("actor_setup")

var i = 0

func _physics_process(delta):
	#print(chasing)
	if activated:
		check_if_stunned()
		follow_player()
		move_and_slide()
		detect_collisions()
		if i < 10:
			i += 1
			actor_setup()
		else:
			i = 0

func activate():
	activated = true
	start_chase_timeout()
	$AnimationPlayer.play("walk")

func detect_collisions():
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		if collision.get_collider().name.begins_with("Player") and !stunned:
			respawn()
			Signals.emit_signal("player_hit")
			break

func respawn():
	print("respawn")
	var closest_spawn_point
	var closest_distance
	for point in spawn_points_node.get_children():
		var distance_to_player = player.position.distance_to(point.position)
		if distance_to_player > 2000 and closest_distance == null:
			closest_distance = distance_to_player
			closest_spawn_point = point
		elif distance_to_player > 2000 and closest_distance > distance_to_player:
			closest_distance = distance_to_player
			closest_spawn_point = point
	position = closest_spawn_point.position
	stunned = false
	chasing = true

func actor_setup():
	await get_tree().physics_frame
	set_movement_target(player.position)

func set_movement_target( movement_target ):
	navigation_agent.target_position = movement_target
	
func follow_player():
	if chasing:
		movement_speed = 350
	else:
		movement_speed = 60

	if stunned:
		velocity.x = move_toward(velocity.x, 0, 20 / (position.distance_to(player.position)/80))
		velocity.y = move_toward(velocity.y, 0, 20 / (position.distance_to(player.position)/80))
		$AnimationPlayer.pause()
	else:
		$AnimationPlayer.play()
		if navigation_agent.is_navigation_finished():
			return
		var current_agent_position = global_position
		var next_path_position = navigation_agent.get_next_path_position()
		velocity = current_agent_position.direction_to(next_path_position) * movement_speed
			
		rotation = lerp_angle(rotation, position.angle_to_point(player.position)+PI, 0.1)

func check_if_stunned():
	if player.flashlight_state and player.check_if_in_light(self):
		$StunTimer.start(stun_time)
		stunned = true

func _on_stun_timer_timeout():
	stunned = false

func _on_chase_timer_timeout():
	if $ChaseEndDetector.has_overlapping_bodies():
		print("chase timeout ended")
		chasing = false

func _on_chase_end_detector_body_exited(body):
	if activated:
		print("after chase respawn")
		respawn()

func _on_chase_start_detector_body_entered(body):
	if activated and chasing:
		start_chase_timeout()

func start_chase_timeout():
	print("chase timeout started")
	if $ChaseTimer.is_stopped():
		$ChaseTimer.start()
