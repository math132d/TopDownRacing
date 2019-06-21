signal collision(position)

extends KinematicBody2D

export (float) var acceleration_speed = 10
export (float) var max_speed = 600
export (float) var turning_speed = 0.00015

export (float) var break_friction = 0.88
export (float) var free_friction = 0.995

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
		acceleration = accelerate(true, Input.get_action_strength("drive_accel"))
	if Input.is_action_pressed("drive_decel"):
		acceleration = accelerate(false, Input.get_action_strength("drive_decel"))
	if Input.is_action_pressed("drive_right"):
		self.rotate(self.velocity *  turning_speed * Input.get_action_strength("drive_right"))
	if Input.is_action_pressed("drive_left"):
		self.rotate(self.velocity * -turning_speed * Input.get_action_strength("drive_left"))
	
	if Input.is_action_pressed("drive_break"):
		self.velocity *= break_friction
	else:
		self.velocity *= free_friction
		
	self.velocity += acceleration
	
	var collision = move_and_collide(get_move_vector() * delta)
	
	if collision:
		if just_collided:
			Input.start_joy_vibration(joypads[0], 0.2, 1, 0.1)
			just_collided = false
			
		velocity = 0
	else:
		just_collided = true
		

func accelerate(forward, strength):
	
	#Logarithmic?
	#var base = pow(max_speed, (1/acceleration_speed))
	#var scaled_acc = acceleration_speed - clamp((log(velocity)/log(base)), 0, acceleration_speed)
	
	#Linear acceleration
	
	var b = acceleration_speed/max_speed
	var abs_velocity
	
	if forward:
		abs_velocity = clamp(self.velocity, 0, max_speed)
		#print("abs_vel: " + str(abs_velocity))
		return (acceleration_speed - b*abs_velocity) * strength
	else:
		abs_velocity = -clamp(self.velocity, -max_speed, 0)
		#print("abs_vel: " + str(abs_velocity))
		return (acceleration_speed - b*abs_velocity) * -strength
	
func get_move_vector():
	var x = cos(self.rotation - PI/2) * self.velocity
	var y = sin(self.rotation - PI/2) * self.velocity
	
	return Vector2(x, y)