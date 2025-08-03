extends Weather


func start_weather():
	super.start_weather()
	$ThunderEffect.show()
	$ThunderBackground.show()


func end_weather():
	super.end_weather()
	$ThunderEffect.hide()
	$ThunderBackground.hide()
	
