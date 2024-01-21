extends Node2D

@export var player : CharacterBody2D
#
#@export var INITATE_JUMP_SOUND = preload("res://audio/effects/FurFly_PLYR_Initiate_Jump.wav")
#
#@export var CHARGING_SOUND = preload("res://audio/effects/FurFly_PLYR_Charging.wav")
#
#@export var CHARGING_FULL_SOUND = preload("res://audio/effects/FurFly_PLYR_ChargedFull.wav")
#
#@export var MUSIC_SOUND = preload("res://audio/music/FurFly_Music_Master.wav")
#
#@export var JUMP_SOUND_LIST : Array[Resource] = [
	#preload("res://audio/effects/FurFly_PLYR_Jump_1.wav"),
	#preload("res://audio/effects/FurFly_PLYR_Jump_2.wav"),
	#preload("res://audio/effects/FurFly_PLYR_Jump_3.wav"),
#]
#
#@export var RETRO_JUMP_SOUND_LIST : Array[Resource] = [
	#preload("res://audio/effects/FurlFly_Retro_Jump_1.wav"),
	#preload("res://audio/effects/FurlFly_Retro_Jump_2.wav"),
	#preload("res://audio/effects/FurlFly_Retro_Jump_3.wav"),
	#preload("res://audio/effects/FurlFly_Retro_Jump_4.wav"),
	#preload("res://audio/effects/FurlFly_Retro_Jump_5.wav"),
#]
#
#@export var GRAB_SOUND_LIST : Array[Resource] = [
	#preload("res://audio/effects/FurFly_PLYR_Grab_1.wav"),
	#preload("res://audio/effects/FurFly_PLYR_Grab_2.wav"),
	#preload("res://audio/effects/FurFly_PLYR_Grab_3.wav"),
	#preload("res://audio/effects/FurFly_PLYR_Grab_4.wav"),
#]
#
#@export var LAND_SOUND_LIST : Array[Resource] = [
	#preload("res://audio/effects/FurFly_PLYR_Land_1.wav"),
	#preload("res://audio/effects/FurFly_PLYR_Land_2.wav"),
	#preload("res://audio/effects/FurFly_PLYR_Land_3.wav"),
	#preload("res://audio/effects/FurFly_PLYR_Land_4.wav"),
	#preload("res://audio/effects/FurFly_PLYR_Land_5.wav"),
#]

@export var PLYR_WALK_SOUND_LIST : Array[Resource] = [
	preload("res://audio/DL_Player_Walk_1.wav"),
	preload("res://audio/DL_Player_Walk_2.wav"),
	preload("res://audio/DL_Player_Walk_3.wav"),
	preload("res://audio/DL_Player_Walk_4.wav"),
	preload("res://audio/DL_Player_Walk_5.wav"),
	preload("res://audio/DL_Player_Walk_6.wav"),
	preload("res://audio/DL_Player_Walk_7.wav"),
	preload("res://audio/DL_Player_Walk_8.wav"),
	preload("res://audio/DL_Player_Walk_9.wav"),
	preload("res://audio/DL_Player_Walk_10.wav"),
	preload("res://audio/DL_Player_Walk_11.wav"),
	preload("res://audio/DL_Player_Walk_12.wav"),
	preload("res://audio/DL_Player_Walk_13.wav"),
	preload("res://audio/DL_Player_Walk_14.wav"),
	preload("res://audio/DL_Player_Walk_15.wav"),
	preload("res://audio/DL_Player_Walk_16.wav"),
	preload("res://audio/DL_Player_Walk_16.wav"),
	preload("res://audio/DL_Player_Walk_17.wav"),
	preload("res://audio/DL_Player_Walk_18.wav"),
	preload("res://audio/DL_Player_Walk_19.wav"),
	preload("res://audio/DL_Player_Walk_20.wav"),
]

@export var AMBIENT_SOUND = preload("res://audio/DL_MainAmbience.wav")

func _physics_process(delta):
	if player:
		position = player.position

func play_ambient(sound, volume_db : float = 20.0, pitch_scale : float = 1.0):
	play_stream($AmbiencePlayer, sound, volume_db, pitch_scale)
	
func play_music(sound, volume_db : float = 0.0, pitch_scale : float = 1.0):
	play_stream($MusicPlayer, sound, volume_db, pitch_scale)

func play_plyr(sound, volume_db : float = 0.0, pitch_scale : float = 1.0):
	for audioStreamPlayer in $PlyrPlayers.get_children():
		if not audioStreamPlayer.playing:
			play_stream(audioStreamPlayer, sound, volume_db, pitch_scale)
			break

func play_ui(sound, volume_db : float = 0.0, pitch_scale : float = 1.0):
	for audioStreamPlayer in $UIPlayers.get_children():
		if not audioStreamPlayer.playing:
			play_stream(audioStreamPlayer, sound, volume_db, pitch_scale)
			break
#
func play_stream(audioStreamPlayer : AudioStreamPlayer2D, sound, volume_db, pitch_scale):
	audioStreamPlayer.volume_db = volume_db
	audioStreamPlayer.pitch_scale = pitch_scale
	audioStreamPlayer.stream = sound
	audioStreamPlayer.play()

func stop_music():
	$AnimationPlayerMusic.play("stop_music")

func start_music():
	$AnimationPlayerMusic.play("start_music")
	$MusicPlayer.play(0)

func start_main_ambient():
	$AnimationPlayerAmbience.play("start_ambient")
	
func _on_audio_stream_player_finished():
	if !stop_music:
		$MusicPlayer.play()

func _on_ambience_player_finished():
	$AmbiencePlayer.play()
