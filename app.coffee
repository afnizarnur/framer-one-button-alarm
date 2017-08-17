# Statusbar time
setTime = () ->
	date = new Date
	minute = date.getMinutes()
	hour = date.getHours()
	
	if hour < 10
		hour = '0' + hour 
	
	if minute < 10
		minute = '0' + minute 

	statusBarTime.text = "#{hour}:#{minute}"

	Utils.delay 30, ->
		setTime()
		
setTime()

# When holding the button
purpleForce = new Gradient
	start: "#3B1FA5"
	end: "#331367"

button.states =
	tapped:
		gradient: purpleForce
		animationOptions:
			time: 0.1
			curve: Bezier.ease

button.onTap (event, layer) ->
	button.animate("tapped")

button.onForceTapEnd ->
	button.animate("default")