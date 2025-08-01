extends Weather


func start_weather():
	super.start_weather()
	time_to_update = 5.
	$ThunderEffect.show()
	$ThunderBackground.show()


func end_weather():
	super.end_weather()
	$ThunderEffect.hide()
	$ThunderBackground.hide()


func next_weather(
	weather_time: float, temperature: float, cloudiness: float, 
	moisture: float, time: float
	) -> int:
	
	if weather_time > 20.:
		if moisture < 0.8 or cloudiness < 0.8 or randf() < 0.8:
			return weather_type.RAIN
		if moisture < 0.4 or cloudiness < 0.4 or randf() < 0.4:
			return weather_type.CLEAR
	
	return weather_type.THUNDER
	
