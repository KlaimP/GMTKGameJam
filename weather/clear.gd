extends Weather

@export var temp_rise: float = 0.2

func start_weather():
	super.start_weather()

func end_weather():
	super.end_weather()



func change_temperature(
	temperature: float, temp_edges: Vector2, cloudiness: float,
	temp_change: float, time: float, delta: float
	) -> float:
	
	temperature += temp_change * (time + temp_rise) * (1.2 - cloudiness) * delta
	return clamp(temperature, temp_edges.x, temp_edges.y)

	
