# Show Hints
Framer.Extras.Hints.disable()

InputModule = require "input"
timer = 
	[
		{ id:1, hours:"4", minutes:"33" },
		{ id:2, hours:"2", minutes:"43" },
		{ id:3, hours:"2", minutes:"43" },
		{ id:3, hours:"2", minutes:"43" },
		{ id:3, hours:"2", minutes:"43" },
		{ id:3, hours:"2", minutes:"43" },
		{ id:3, hours:"2", minutes:"43" },
		{ id:3, hours:"2", minutes:"43" }
		
	]
	
timer_count = 0

# Disable right-click context menu
if document.addEventListener?
	document.addEventListener "contextmenu", (event) ->
		event.preventDefault()

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

# Function
# Check if array null 
Array::present = ->
	@.length > 0

# Button & Alarm Behaviour and States
purple = new Gradient
	start: "#532ED6"
	end: "#B28AF2"

purpleForce = new Gradient
	start: "#3B1FA5"
	end: "#331367"

addButton = button.children[0] 
checkButton = button.children[1] 
closeButton = button.children[2] 
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

closeButton.states =
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
			time: .2
			curve: Bezier.easeIn	
	full:
		height: 470
		y: 40
		animationOptions:
			time: .7
			curve: Spring
	small:
		height: 210
		y: 300
		animationOptions:
			time: .2
			curve: Bezier.easeInOut
	hiddenFull:
		opacity: 0
		scale: 0
		y: 380
		animationOptions:
			time: .2
			curve: Bezier.easeIn

# When adding alarm
inputH = new InputModule.Input
	parent: base_timer
	width: 38
	height: 38
	placeholder: "3"
	x: 60
	y: 26
	fontWeight: "300"
	fontSize: 24
	textAlign: "center"
	virtualKeyboard: false

inputM = new InputModule.Input
	parent: base_timer
	width: 38
	height: 38
	placeholder: "55"
	x: 135
	y: 26
	fontWeight: "300"
	fontSize: 24
	textAlign: "center"
	virtualKeyboard: false
  
inputH.style =
	textAlign: "center"
  
inputM.style =
	textAlign: "center"

# ScrollComponent for Window Alarm
scrollExisting = new ScrollComponent
	z: -1
	y: 50
	parent: add_alarm
	width: add_alarm.width
	height: 420
	scrollHorizontal: false
	backgroundColor: "transparent"

scrollExisting.states = 
	small: 
		contentInset:
			bottom: 20
		height: 161
		animationOptions:
			time: .1
			curve: Bezier.easeInOut
	full: 
		contentInset:
			bottom: 20
		height: 470
		animationOptions:
			time: .3	
			curve: Bezier.easeInOut
			
wrapper_content.parent = scrollExisting.content
		
# States for Add Alarm container
wrapper_add.states = 
	active:
		x: 0
		animationOptions:
			time: .5
			curve: Bezier.ease
	hidden:
		x: 350
		animationOptions:
			time: .2
			curve: Bezier.easeIn
		

# When Button onTap
button.onTap (event, layer) ->
	scrollExisting.scrollVertical = true
	scrollExisting.z = 0
	scrollExisting.stateSwitch("small")
	wrapper_add.parent = scrollExisting.content
	wrapper_content.y = 0
	add_alarm.height = 210
	if this.states.current.name is "tapped"
		button.animate("normal")
		addButton.animate("active")
		checkButton.animate("hidden")
		closeButton.animate("hidden")
		maximize.animate("default")
		existing.stateSwitch("default")
		wrapper_list.stateSwitch("hidden")
		wrapper_empty.stateSwitch("hidden")

		if add_alarm.states.current.name is "full"
			add_alarm.height = 470
			add_alarm.animate("hiddenFull")
		else
			add_alarm.animate("hidden")
	else 
		button.animate("tapped")
		addButton.animate("hidden")
		checkButton.animate("active")
		closeButton.animate("hidden")
		add_alarm.animate("active")
		wrapper_add.stateSwitch("active")	
		
		# Insert to JSON Array
		if inputH.value != "" && inputM.value != ""
			timer_count++
			data = 
				id: timer_count
				hours: inputH.value
				minutes: inputM.value
			timer.push data

# Maximize states
maximize.states =
	disable:
		opacity: .3
		animationOptions:
			time: .2
			curve: Bezier.easeInOut
	default:
		opacity: 1
		animationOptions:
			time: .2
			curve: Bezier.easeInOut

# When maximize onTap
maximize.onTap (event, layer) ->
	if add_alarm.height <= 210
		add_alarm.animate("full")
		scrollExisting.animate("full")
	else if wrapper_empty.states.current.name is "active" or wrapper_list.states.current.name is "active" 
		add_alarm.animate("full")
		scrollExisting.animate("full")
	else
		add_alarm.animate("small")
		scrollExisting.animate("small")

# When timer empty
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
		animationOptions:
			time: .4
			curve: Spring

# When timer not empty
wrapper_list.states =			
	active:
		x: 0
		animationOptions:
			time: .5
			curve: Bezier.ease
	hidden:
		x: -350
		animationOptions:
			time: .2
			curve: Bezier.easeIn

wrapper_empty.stateSwitch("hidden")
wrapper_list.stateSwitch("hidden")
wrapper_content.parent = scrollExisting.content

# When user tap existing page
existing.states =
	active:
		borderColor: "#7755CC"
		animationOptions:
			time: .3
			curve: Bezier.easeInOut
	default:
		borderColor: "#DDDDDD"
		animationOptions:
			time: .3
			curve: Bezier.easeInOut

for item, index in timer
	hours = item.hours
	minutes = item.minutes
	
	alarm_item.copy().parent = wrapper_list 
	wrapper_list.children[index].children[2].template =
		h: hours
		m: minutes
	wrapper_list.children[index].y = 60 * index
	
wrapper_list.children[0].destroy()
	
existing.onTap (event, layer) ->
	if existing.states.current.name isnt "active"
		wrapper_add.animate("hidden")
		Utils.delay .2, ->
			scrollExisting.stateSwitch("full")
			add_alarm.animate("full")
		if timer.present()
			wrapper_list.parent = scrollExisting.content
			existing.animate("active")
			maximize.animate("disable")
			addButton.animate("hidden")
			checkButton.animate("hidden")
			closeButton.animate("active")
			wrapper_content.height = 420
			scrollExisting.scrollVertical = true
			
			Utils.delay 0.4, ->
				wrapper_list.animate("active")
		else
			wrapper_empty.parent = wrapper_content
			existing.animate("active")
			if wrapper_empty.states.current.name isnt "active"
				maximize.animate("disable")
				wrapper_content.height = 420
				scrollExisting.z = 0
				scrollExisting.scrollVertical = false
				addButton.animate("hidden")
				checkButton.animate("hidden")
				closeButton.animate("active")
				
				Utils.delay 0.3, ->
					wrapper_empty.animate("active")
	else 
		existing.animate("default")
		maximize.animate("default")
		addButton.animate("hidden")
		checkButton.animate("active")
		closeButton.animate("hidden")
		wrapper_empty.animate("hidden")
		wrapper_list.animate("hidden")
		scrollExisting.scrollVertical = true
		Utils.delay .2, ->
			wrapper_add.animate("active")



