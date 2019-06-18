signal collision(position)

extends KinematicBody2D

export (float) var acceleration_speed = 60
export (float) var turning_speed = 0.0001
export (float) var friction = 0.88

export (PackedScene) var sparks

var just_collided = false
var velocity = 0
var joypads

func _ready():
	joypads = Input.get_connected_joypads()
	print(joypads)
	
func _physics_process(delta):
	var acceleration = 0

	if Input.is_action_pressed("drive_accel"):
		acceleration = acceleration_speed * Input.get_action_strength("drive_accel")
	if Input.is_action_pressed("drive_decel"):
		acceleration = -acceleration_speed * Input.get_action_strength("drive_decel")
	if Input.is_action_pressed("drive_right"):
		self.rotate(self.velocity *  turning_speed * Input.get_action_strength("drive_right"))
	if Input.is_action_pressed("drive_left"):
		self.rotate(self.velocity * -turning_speed * Input.get_action_strength("drive_left"))
		
	self.velocity += acceleration
	
	self.velocity *= friction
	
	var collision = move_and_collide(get_move_vector() * delta)
	
	if collision:
		if just_collided:
			Input.start_joy_vibration(joypads[0], 0.2, 1, 0.1)
			just_collided = false
			
		velocity = 0
	else:
		just_collided = true
		
	
	
func get_move_vector():
	var x = cos(self.rotation - PI/2) * self.velocity
	var y = sin(self.rotation - PI/2) * self.velocity
	
	return Vector2(x, y)