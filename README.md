# Swift Discord Bot

### Deploy to Heroku

[![Deploy](https://www.herokucdn.com/deploy/button.svg)](https://heroku.com/deploy)

```terminal.sh-session
git clone https://github.com/hoclos/SwiftDiscordBot.git
cd SwiftDiscordBot
heroku container:login
heroku create
heroku config:set DISCORD_TOKEN="<discord token here>"
heroku container:push worker --arg DOCKER_IMAGE=norionomura/swift:5.0
```
Configure Dyno on your [Heroku Dashboard](https://dashboard.heroku.com/apps)

## Author

Norio Nomura

## License

Swift Compiler Discordapp Bot is available under the MIT license. See the LICENSE file for more info.

