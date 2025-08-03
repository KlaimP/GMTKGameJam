extends Weather


func start_weather():
	super.start_weather()
	$MistEffect.show()

func end_weather():
	super.end_weather()
	$MistEffect.hide()
