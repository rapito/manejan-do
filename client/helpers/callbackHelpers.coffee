@MCError = (err)->
	if _.isValid err
		console.err("error", err)
		true
	false