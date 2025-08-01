extends Weather


func start_weather():
	super.start_weather()

func end_weather():
	super.end_weather()


func change_weather(
	weather_time: float, temperature: float, cloudiness: float, 
	moisture: float, time: float
	) -> int:
	
	return weather_type.BLIZZARD
	
