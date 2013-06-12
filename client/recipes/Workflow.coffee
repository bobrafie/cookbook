class @Workflow
	
	constructor: (@events, @transitions, @currentState) ->
	
	transit : (currentStep) ->
		@events[_.indexOf(@events, _.where(@events, {id:currentStep[0]})[0])].done = true
		eligibleSteps = []
		eligibleSteps.push _.where(@transitions, {from:s}) for s in currentStep
		eligibleSteps = _.flatten(eligibleSteps)
		if eligibleSteps.length is 0
			eligibleSteps = _.find @transitions, (transition) =>
				found = false
				sortedCurrentState = @currentState[..].sort()
				_.each sortedCurrentState, (s, index) ->
					if s is transition.from[index]
						return found = true
				found
			okToProcede = true
			_.each eligibleSteps.from, (s, index) =>
				done = @events[_.indexOf(@events, _.where(@events, {id:s})[0])].done
				if !done? or done isnt true
					okToProcede = false
			if !okToProcede
				return currentStep
			#console.debug('I FOUND', eligibleSteps, 'for', currentStep)
			eligibleSteps = [eligibleSteps]
		eligibleSteps = _.pluck(eligibleSteps, 'to')
		eligibleSteps = _.uniq(eligibleSteps,false,(i) ->
			i[0]
		)
		eligibleSteps = _.flatten(eligibleSteps)
		if (@currentState.length > 1) and !(@typeIsArray _.where(@transitions, {to:eligibleSteps[0]})[0].from)
			@currentState[_.indexOf(@currentState, currentStep[0])] = eligibleSteps
			@currentState = _.flatten(@currentState)
		else
			@currentState = eligibleSteps
		eligibleSteps

	typeIsArray : Array.isArray || ( value ) -> return {}.toString.call( value ) is '[object Array]'