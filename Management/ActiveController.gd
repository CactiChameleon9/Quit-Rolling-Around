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
		
		# connect the finished signal if it exists and
		#  if the failed finished isn't already connected
		if (get_child(i).has_signal("scene_finished") and
			get_child(i).get_signal_connection_list("scene_finished") == []):
			
			get_child(i).connect("scene_finished", self, child_finished())
		
		
		# connect the failed signal if it exists and
		#  if the failed signal isn't already connected
		if (get_child(i).has_signal("scene_failed") and
			get_child(i).get_signal_connection_list("scene_failed") == []):
			
			get_child(i).connect("scene_failed", self, child_failed())


func child_finished():
	# designed to be called from a signal
	current_active += 1
	if current_active >= len(get_children()):
		current_active = 0


func child_failed():
	# designed to be called from a signal
	current_active -= 1
	if current_active < 0:
		current_active = len(get_children()) - 1
