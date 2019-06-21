extends Line2D

export (NodePath) var target
export var length=20

func _on_Timer_timeout():
	add_point(get_node(target).global_position)
	
	while get_point_count() > length:
		remove_point(0)
