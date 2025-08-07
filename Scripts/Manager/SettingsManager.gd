extends Node
class_name SettingsManager

static var masterVolume: float = 1
static var musicVolume: float = 1
static var sfxVolume: float = 1

static func _get_display_mode():
	return DisplayServer.window_get_mode()

static func _update_display_mode(displayMode : DisplayServer.WindowMode , save : bool = true):
	DisplayServer.window_set_mode(displayMode)
	if save : ConfigFileManager._save_fullscreen_mode(displayMode)
	
static func _get_vsync_mode():
	return DisplayServer.window_get_vsync_mode()
	
static func _update_Vsync_mode(vsyncMode : DisplayServer.VSyncMode, save : bool = true):
	DisplayServer.window_set_vsync_mode(vsyncMode)
	if save : ConfigFileManager._save_vsync_mode(vsyncMode)
	
static func _update_master_volume(_volume : float, save : bool = true):
	masterVolume = _volume
	var index = AudioServer.get_bus_index("Master")
	var volume = 20 * (log(_volume) / log(10))
	AudioServer.set_bus_volume_db(index,volume)
	if save : ConfigFileManager._save_master_volume(_volume)
	
static func _update_music_volume(_volume : float, save : bool = true):
	musicVolume = _volume
	var index = AudioServer.get_bus_index("Music")
	var volume = 20 * (log(_volume) / log(10))
	AudioServer.set_bus_volume_db(index,volume)
	if save : ConfigFileManager._save_music_volume(_volume)
	
static func _update_sfx_volume(_volume : float, save : bool = true):
	sfxVolume = _volume
	var index = AudioServer.get_bus_index("SFX")
	var volume = 20 * (log(_volume) / log(10))
	AudioServer.set_bus_volume_db(index,volume)
	if save : ConfigFileManager._save_sfx_volume(_volume)
