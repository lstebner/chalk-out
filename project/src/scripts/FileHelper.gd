extends Node

func write(filename, data):
	var file = File.new()
	file.open(filename, File.WRITE)
	file.store_var(data, true)
	file.close()
	
func read(filename):
	var file = File.new()
	var contents = null
	
	if file.file_exists(filename):
		file.open(filename, File.READ)
		contents = file.get_var(true)
		
	file.close()
	return contents
