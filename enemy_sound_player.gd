extends Node2D

@export var enemy : CharacterBody2D

@export var MONSTER_APPEAR_SOUND = preload("res://audio/DL_MonsterAppear_Distance.wav")

@export var MONSTER_DISSAPPEAR_SOUND = preload("res://audio/DL_MonsterDissappear.wav")

@export var MONSTER_CHASE_SOUND = preload("res://audio/DL_Monster_Chase_Ambience.wav")

@export var MONSTER_MAIN_NOISE_SOUND = preload("res://audio/DL_Monster_MainNoise.wav")

func _physics_process(delta):
	if enemy:
		position = enemy.position

func play_enemy(sound, volume_db : float = 0.0, pitch_scale : float = 1.0):
	for audioStreamPlayer in $EnemyPlayers.get_children():
		if not audioStreamPlayer.playing:
			play_stream(audioStreamPlayer, sound, volume_db, pitch_scale)
			break
			
func play_distance_enemy(sound, volume_db : float = 0.0, pitch_scale : float = 1.0):
	for audioStreamPlayer in $DistanceEnemyPlayers.get_children():
		if not audioStreamPlayer.playing:
			play_stream(audioStreamPlayer, sound, volume_db, pitch_scale)
			break
#
func play_stream(audioStreamPlayer : AudioStreamPlayer2D, sound, volume_db, pitch_scale):
	audioStreamPlayer.volume_db = volume_db
	audioStreamPlayer.pitch_scale = pitch_scale
	audioStreamPlayer.stream = sound
	audioStreamPlayer.play()

func play_chase_ambience():
	$AnimationPlayerChase.play("chase_start")

func stop_chase_ambience():
	$AnimationPlayerChase.play("chase_stop")
	
func play_enemy_noise():
	$EnemyMainAudioStreamPlayer2D.play()

func _on_enemy_main_audio_stream_player_2d_finished():
	$EnemyMainAudioStreamPlayer2D.play()
