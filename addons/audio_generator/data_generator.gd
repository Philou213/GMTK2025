extends Object
class_name AudioDataGenerator

### GENERATES THE DATA (ENUM AND DICTIONNARY) TO FIND AUDIO FILES MORE EASILY

func generate(input_dir: String, output_path: String, enum_name: String, dictionnary_name : String, classname: String):
	# Open directory
	var dir := DirAccess.open(input_dir)
	if dir == null:
		push_error("Could not open music directory.")
		return

	var enum_entries := []
	var dict_entries := []

	# Get all files
	var files := dir.get_files()
	files.sort()

	# If Audiofile, get his info
	for file in files:
		if file.ends_with(".mp3") or file.ends_with(".ogg") or file.ends_with(".wav"):
			var name := file.get_basename().to_upper().replace(" ", "_")
			var path := "%s/%s" % [input_dir, file]
			enum_entries.append("\t%s," % name)
			dict_entries.append("\t%s.%s: preload(\"%s\")" % [enum_name, name, path])

	if enum_entries.size() > 0:
		enum_entries[enum_entries.size() - 1] = enum_entries[-1].rstrip(",")

# Generate the auto_generated script
	var content := """# Auto-generated
class_name %s

enum %s {
%s
}

static var %s = {
%s
}
""" % [classname, enum_name, "\n".join(enum_entries), dictionnary_name, ",\n".join(dict_entries)] # Add the data in the script

	# Save the script
	var file := FileAccess.open(output_path, FileAccess.WRITE)
	if file:
		file.store_string(content)
		file.close()
		print("Generated music data at:", output_path)
		print("You need to start the game to refresh the script")
	else:
		push_error("Failed to write file.")
