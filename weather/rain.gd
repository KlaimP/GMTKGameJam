extends Weather



func start_weather():
	super.start_weather()
	$RainEffect.show()
	$RainBackground.show()


func end_weather():
	super.end_weather()
	$RainEffect.hide()
	$RainBackground.hide()


func next_weather(
	weather_time: float, temperature: float, cloudiness: float, 
	moisture: float, time: float
	) -> int:
	
	if weather_time > 10. and randf() < 0.5:
		return weather_type.THUNDER
	if (moisture < 0.5 or cloudiness < 0.5) and randf() < 0.6:
		return weather_type.CLEAR
	
	return weather_type.RAIN
	
