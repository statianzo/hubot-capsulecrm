# Description:
#   Display stats from New Relic
#
# Dependencies:
#
# Configuration:
#   HUBOT_CAPSULE_API_KEY
#   HUBOT_CAPSULE_API_HOST
#
# Commands:
#   hubot capsule users - Returns a list of Capsule users
#
# Author:
#   statianzo
#

module.exports = plugin = (robot) ->
  apiKey = process.env.HUBOT_CAPSULE_API_KEY
  apiHost = process.env.HUBOT_CAPSULE_API_HOST
  apiBaseUrl = "https://#{apiHost}/api/"
  config = {}

  request = (path, params, cb) ->
    robot.http(apiBaseUrl + path)
      .header('Accept', 'application/json')
      .auth(apiKey, 'x')
      .get() (err, res, body) ->
        console.log body, res, err
        if err
          cb(err)
        else
          json = JSON.parse(body)
          if json.error
            cb(new Error(body))
          else
            cb(null, json)

  robot.respond /capsule users/i, (msg) ->
    request 'users', {}, (err, json) ->
      if err
        msg.send "Failed: #{err.message}"
      else
        msg.send plugin.users json.users.user


plugin.users = (users) ->
  lines = users.map (u) ->
    "#{u.name} (#{u.username})"

  lines.join("\n")
