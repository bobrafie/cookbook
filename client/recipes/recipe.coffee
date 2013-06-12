Template.recipe.helpers
		recipe : ->
			recipe = Recipes.findOne Session.get 'currentRecipeId'
			if recipe?
				Session.set 'steps', _.map(recipe.steps, (step) ->
					_.pick step, 'id'
				) if not (Session.get 'steps')?
				Session.set 'step', ['0'] if not (Session.get 'step')?
				Session.set 'transitions', recipe.transitions
			recipe
		step : ->
			steps = Session.get 'step'
			recipe = Recipes.findOne Session.get 'currentRecipeId'
			if (steps? and recipe?)
				s = []
				if (steps.length?)
					for step in steps
						s.push _.where(recipe.steps, {id : step})
				else
					s = _.where(recipe.steps, {id : steps})
				_.flatten(s)
			
Template.recipe.events
		'click button#start' : (event) ->
			steps = Session.get 'steps'
			step = Session.get 'step'
			transitions = Session.get 'transitions'
			currentStep = step
			w = new Workflow(steps, transitions, step)
			newStep = w.transit(currentStep)
			Session.set 'step', newStep
		'click button.done' : (event) ->
			currentStep = [$(event.target).attr('id')]
			steps = Session.get 'steps'
			step = Session.get 'step'
			transitions = Session.get 'transitions'
			w = new Workflow(steps, transitions, step)
			newStep = w.transit(currentStep)
			Session.set 'step', w.currentState
			Session.set 'steps', w.events
