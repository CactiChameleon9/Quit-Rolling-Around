extends Node

var current_active : int = 0


func _process(_delta):
	the_connecting()
	the_pausing()


func the_pausing():
	# iterate through the children, allowing only the current active node to run
	for i in len(get_children()):
		get_child(i).pause_mode = 0 if i == current_active else 1


func the_connecting():
	# iterate through the children and connect up the child_finished method
	for i in len(get_children()):
		# don't connect the signal if it doesn't exist
		if not get_child(i).has_signal("finished_active"):
			continue
		
		# don't connect the signal if already connected
		if get_child(i).get_signal_connection_list("finished_active") == []:
			continue
		
		get_child(i).connect("finished_active", self, child_finished())


func child_finished():
	# designed to be called from a signal
	current_active += 1
	if current_active >= len(get_children()):
		current_active = 0
