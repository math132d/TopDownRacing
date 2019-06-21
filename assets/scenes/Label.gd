extends Label

func _process(delta):
	self.text = str(1 / delta)