extends Node3D

@onready var truck = $trucka
@onready var ambulance = $ambulancia
@onready var gadget = $Label
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if truck.crashed:
		gadget.text = "ACTIVADO!\nmandando localizacion"
		var crash_point = truck.global_position
		
		ambulance.position.z = crash_point.z+3
		
		# activar cuando tenemos respuesta de api?
		if abs(ambulance.position.x - crash_point.x) > 4:
			ambulance.position.x -= 0.5
		
