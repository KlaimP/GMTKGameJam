extends Weather


func start_weather():
	super.start_weather()
	$DroughtEffect.show()
	$DroughtBackground.show()

func end_weather():
	super.end_weather()
	$DroughtEffect.hide()
	$DroughtBackground.hide()



	
