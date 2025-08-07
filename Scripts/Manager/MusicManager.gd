extends Node

const MUTE_DB : float = -80

@export var music_volume : float = -6

var pool_size : int = 2
var channel_pool : Array[AudioStreamPlayer] = []
var current_channel_index : int = 0

func _ready() -> void:
	_initialize_audio_streams()

func _initialize_audio_streams():
	for i in range(pool_size):
		var audio_player = AudioStreamPlayer.new()
		audio_player.volume_db = music_volume
		audio_player.bus = "Music"
		add_child(audio_player)
		channel_pool.append(audio_player)

func crossfade_music(track : MusicData.Track, fade_duration : float) -> void:
	fade_music_out(fade_duration)
	current_channel_index = 1 - current_channel_index
	fade_music_in(MusicData.Audio_Dictionnary[track], fade_duration)

func fade_music_in(track : MusicData.Track, fade_time : float):
	var music_player : AudioStreamPlayer = channel_pool[current_channel_index]
	music_player.stream = MusicData.Audio_Dictionnary[track]
	music_player.volume_db = MUTE_DB
	music_player.play()
	
	#Fade in
	var tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO)
	tween.tween_property(music_player, "volume_db", music_volume, fade_time)
	
func fade_music_out(fade_time : float):
	var music_player : AudioStreamPlayer = channel_pool[current_channel_index]
	
	#Fade out
	var tween = create_tween().set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_SINE)
	tween.tween_property(music_player, "volume_db", MUTE_DB, fade_time)
	
	#Stop the music_player
	tween.tween_callback(func(): music_player.stop())
