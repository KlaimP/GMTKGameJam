extends Weather

func start_weather():
	super.start_weather()

func end_weather():
	super.end_weather()

func _ready() -> void:
	time_to_update = 5.


func next_weather(
	weather_time: float, temperature: float, cloudiness: float, 
	moisture: float, time: float
	) -> int:
	
	if temperature > 0. and cloudiness > 0.45 and moisture > 0.4 and randf() < 0.25:
		return weather_type.RAIN
	
	return weather_type.CLEAR
	
