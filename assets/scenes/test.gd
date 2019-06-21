extends Node2D

export (PackedScene) var sparks

func _on_KinematicBody2D_collision(position):
	
	var tmp_sparks = sparks.instance()
	tmp_sparks.position = Vector2(20,20)
	
	get_node(".").add_child(tmp_sparks)
