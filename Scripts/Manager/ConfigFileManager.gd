class_name ConfigFileManager

static var configFile = ConfigFile.new()
const SETTINGS_FILE_PATH = "user://settings.ini"

const VIDEO = "video"
const FULLSCREEN = "fullscreenMode"
const VSYNC = "vsyncMode"

const AUDIO = "audio"
const MASTER_VOLUME = "masterVolume"
const MUSIC_VOLUME = "musicVolume"
const SFX_VOLUME = "sfxVolume"

const DEFAULT_FULLSCREEN = DisplayServer.WINDOW_MODE_FULLSCREEN
const DEFAULT_VSYNC = DisplayServer.VSYNC_DISABLED

const DEFAULT_MASTER_VOLUME = 1
const DEFAULT_MUSIC_VOLUME = 1
const DEFAULT_SFX_VOLUME = 1


static var config_template = {
	VIDEO: {
		FULLSCREEN: DEFAULT_FULLSCREEN,
		VSYNC: DEFAULT_VSYNC
	},
	AUDIO: {
		MASTER_VOLUME: DEFAULT_MASTER_VOLUME,
		MUSIC_VOLUME: DEFAULT_MUSIC_VOLUME,
		SFX_VOLUME: DEFAULT_SFX_VOLUME
	}
}

static func _init() -> void:
	_load_config()

static func _load_config():
	if !FileAccess.file_exists(SETTINGS_FILE_PATH):
		_init_config()
	else:
		configFile.load(SETTINGS_FILE_PATH)
		_verify_config()
	_apply_config()
		
#Apply config values to the game
static func _apply_config():
	SettingsManager._update_display_mode(configFile.get_value(VIDEO,FULLSCREEN),false)
	SettingsManager._update_Vsync_mode(configFile.get_value(VIDEO,VSYNC),false)
	
	SettingsManager._update_master_volume(configFile.get_value(AUDIO,MASTER_VOLUME),false)
	SettingsManager._update_music_volume(configFile.get_value(AUDIO,MUSIC_VOLUME),false)
	SettingsManager._update_sfx_volume(configFile.get_value(AUDIO,SFX_VOLUME),false)
		
#Create the config file at first launch
static func _init_config():
	for section in config_template.keys():
		for key in config_template[section].keys():
			configFile.set_value(section, key, config_template[section][key])
		
	configFile.save(SETTINGS_FILE_PATH)
		
#Check if the config template is correct
static func _verify_config():
	var is_config_updated = false

	for section in config_template.keys():
		for key in config_template[section].keys():
			if !configFile.has_section_key(section, key):
				print("Adding missing key: ", section, "/", key)
				configFile.set_value(section, key, config_template[section][key])
				is_config_updated = true

	if is_config_updated:
		configFile.save(SETTINGS_FILE_PATH)
		print("Config file updated with missing values.")
		
static func _save_fullscreen_mode(fullscreenMode : DisplayServer.WindowMode):
	configFile.set_value(VIDEO,FULLSCREEN, fullscreenMode)
	configFile.save(SETTINGS_FILE_PATH)
	
static func _save_vsync_mode(vsyncMode : DisplayServer.VSyncMode):
	configFile.set_value(VIDEO,VSYNC, vsyncMode)
	configFile.save(SETTINGS_FILE_PATH)

static func _save_master_volume(volume : float):
	configFile.set_value(AUDIO,MASTER_VOLUME, volume)
	configFile.save(SETTINGS_FILE_PATH)
	
static func _save_music_volume(volume : float):
	configFile.set_value(AUDIO,MUSIC_VOLUME, volume)
	configFile.save(SETTINGS_FILE_PATH)

static func _save_sfx_volume(volume : float):
	configFile.set_value(AUDIO,SFX_VOLUME, volume)
	configFile.save(SETTINGS_FILE_PATH)
