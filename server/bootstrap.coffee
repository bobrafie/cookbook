class @Bootstrap

	@seedRecipes : ->
		Meteor.http.get Meteor.absoluteUrl('recipes.json'), null, (error, result) ->
			console.log 'AHA!'
			if not error? and result.data?
				console.log result.data
				Recipes.remove {}
				_.each result.data, (recipe) ->
					Recipes.insert recipe
