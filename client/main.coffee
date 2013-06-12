Template.home.greeting = ->
	"Welcome to cookbook."

Template.home.events
	'click input' : ->
		# template data, if any, is available in 'this'
		if console?
			console.debug "You pressed the button"

Template.recipes.helpers
		recipes : ->
			Recipes.find()
							
Meteor.Router.add
	'/': 'home',
	'/count': 'count',
	'/recipes': 'recipes',
	'/recipes/:_id':
		to: 'recipe'
		and: (id) ->
			Session.set 'currentRecipeId', id

Handlebars.registerHelper 'TabActive', (route) =>
	currentPage = Meteor.Router.page()
	if (currentPage is route) then 'active' else ''

Handlebars.registerHelper 'debug', (optionalValue) ->
	console.debug("Current Context")
	console.debug("====================")
	console.debug(this)
	if (optionalValue)
		console.debug("Value")
		console.debug("====================")
		console.debug(optionalValue)
