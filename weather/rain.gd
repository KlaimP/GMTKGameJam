extends Weather



func start_weather():
	super.start_weather()
	$RainEffect.show()
	$RainBackground.show()


func end_weather():
	super.end_weather()
	$RainEffect.hide()
	$RainBackground.hide()
