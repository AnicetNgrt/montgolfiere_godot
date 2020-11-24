extends Node

var music_player:AudioStreamPlayer = null


func play_music(music:AudioStream, volume:float = 1):
	if music_player != null:
		stop_music()
	music_player = AudioStreamPlayer.new()
	music_player.stream = music
	add_child(music_player)
	music_player.volume_db = -1 + volume
	music_player.play()


func stop_music():
	music_player.stop()
	music_player.call_deferred("queue_free")
	music_player = null
