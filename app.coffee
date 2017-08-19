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
	full:
		height: 470
		y: 40
		animationOptions:
			time: .7
			curve: Spring
	small:
		height: 260
		y: 250
		animationOptions:
			time: .7
			curve: Spring
	hiddenFull:
		opacity: 0
		scale: 0
		y: 500
		animationOptions:
			time: 1.4
			curve: Spring

button.onTap (event, layer) ->
	if this.states.current.name is "tapped"
		add_alarm.height = 210
		button.animate("normal")
		addButton.animate("active")
		checkButton.animate("hidden")
		wrapper_empty.stateSwitch("hidden")
		if add_alarm.states.current.name is "full"
			add_alarm.animate("hiddenFull")
		else
			add_alarm.animate("hidden")
	else 
		button.animate("tapped")
		addButton.animate("hidden")
		checkButton.animate("active")
		add_alarm.animate("active")

timer = []

# Check if array null 
Array::present = ->
	@.length > 0

maximize.onTap (event, layer) ->
	if add_alarm.height <= 260
		add_alarm.animate("full")
	else if timer.present() is not true
		add_alarm.stateSwitch("full")
	else
		add_alarm.animate("small")

scrollExisting = new ScrollComponent
	z: -1
	y: 50
	parent: add_alarm
	width: add_alarm.width
	height: 420
	scrollHorizontal: false

wrapper_content.parent = scrollExisting.content
wrapper_empty.parent = wrapper_content

wrapper_empty.states =
	active: 
		opacity: 1
		scale: 1
		x: Align.center
		animationOptions:
			time: .4
			curve: Spring
	hidden:
		opacity: 0
		scale: 0

existing.onTap (event, layer) ->
	add_alarm.animate("full")
	wrapper_empty.stateSwitch("hidden")
	
	if !timer
		print "Empty timer"	
	else
		wrapper_content.height = 470 - 50
		scrollExisting.z = 0
		scrollExisting.scrollVertical = false
		
		Utils.delay 0.3, ->
			wrapper_empty.animate("active")
