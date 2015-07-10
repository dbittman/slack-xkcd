module.exports = (robot) ->
	robot.hear /^xkcd\s*$/i, (res) ->
		res.send "Please enter a query"
	robot.hear /^xkcd (.*)/i, (res) ->
		query_url = "https://relevantxkcd.appspot.com/process?action=xkcd&query=" + res.match[1]
		robot.http(query_url).get() (error, response, body) ->
			if response.statusCode isnt 200
				res.send "Unable to retrieve relevantXKCD data"
				return

			results = body.split(' ')
			if results.length < 2
				res.send "relevantXKCD didn't return any results"
				return
			comic = results[2].replace /^\s+|\s+$/g, ""
			comic_json = "http://xkcd.com/" + comic + "/info.0.json"
			robot.http(comic_json).get() (error_xkcd, response_xkcd, body_xkcd) ->
				if response_xkcd.statusCode isnt 200
					res.send "Unable to retrieve XKCD json data"
					return
				data = JSON.parse body_xkcd
				res.send data.img + "\nAlt Text: " + data.alt

