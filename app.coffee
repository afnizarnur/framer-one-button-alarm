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

# Button Behaviour and States
purple = new Gradient
	start: "#532ED6"
	end: "#B28AF2"

purpleForce = new Gradient
	start: "#3B1FA5"
	end: "#331367"

addButton = button.children[0] 
checkButton = button.children[1] 
checkButton.scale = 0
add_alarm.scale = 0	
add_alarm.y = 500	

button.states =
	normal:
		gradient: purple
		animationOptions:
			time: 1
			curve: Spring
	tapped:
		gradient: purpleForce
		animationOptions:
			time: 1
			curve: Spring
			
addButton.states =
	active: 
		opacity: 1
		scale: 1
		animationOptions:
			time: 0.4
			curve: Spring
	hidden: 
		opacity: 0
		scale: 0
		animationOptions:
			time: 0.4
			curve: Spring

checkButton.states =
	active:
		opacity: 1
		scale: 1
		animationOptions:
			time: 0.4
			curve: Spring
	hidden: 
		opacity: 0
		scale: 0
		animationOptions:
			time: 0.4
			curve: Spring
			
add_alarm.states =
	active:
		opacity: 1
		scale: 1
		y: 300
		animationOptions:
			time: .7
			curve: Spring
	hidden:
		opacity: 0
		scale: 0
		y: 500
		animationOptions:
			time: .7
			curve: Spring

button.onTap (event, layer) ->
	if this.states.current.name is "tapped"
		add_alarm.height = 210
		button.animate("normal")
		addButton.animate("active")
		checkButton.animate("hidden")
		add_alarm.animate("hidden")
	else 
		add_alarm.height = 210
		button.animate("tapped")
		addButton.animate("hidden")
		checkButton.animate("active")
		add_alarm.animate("active")

maximize.onTap (event, layer) ->
	if add_alarm.height <= 260
		add_alarm.height = 470
		add_alarm.y = 40
	else
		add_alarm.height = 260
		add_alarm.y = 250
		
