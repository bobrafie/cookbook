Meteor.startup ->
	# code to run on server at startup
	Meteor.methods
		'Workflow.transit' : (steps, transitions, currentState, fromStep) ->
			console.log steps, transitions, currentState, fromStep
			workflow = new Workflow steps, transitions, currentState
			workflow.transit fromStep
			'currentState' : workflow.currentState
			'steps' : workflow.events
