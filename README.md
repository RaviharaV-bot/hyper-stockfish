[![Build Status](https://github.com/RaviharaV-bot/hyper-stockfish/actions/workflows/docker-image.yml/badge.svg)](https://github.com/RaviharaV-bot/hyper-stockfish/actions) [![Python Build](https://github.com/RaviharaV-bot/hyper-stockfish/actions/workflows/python.yml/badge.svg)](https://github.com/RaviharaV-bot/hyper-stockfish/actions/workflows/python.yml)[![hyper-stockfish release][releaselogo]][releaselink]

# hyper-stockfish

The code template to make a Lichess Bot and deploy it to heroku server easily.
This is the code of [@hyper-stockfish](https://lichess.org/@/hyper-stockfish) and similar heroku run bots in [lichess.org](https://lichess.org)

Engine communication code taken from https://github.com/ShailChoksi/lichess-bot by [ShailChoksi](https://github.com/ShailChoksi)

### Chess Engine

- [Multi Variant Stockfish (Modern CPU)](https://github.com/ddugovic/Stockfish)

### Heroku Buildpack

- [`heroku/python`](https://elements.heroku.com/buildpacks/heroku/heroku-buildpack-python)

### Heroku Stack

- [`Container`](https://devcenter.heroku.com/articles/container-registry-and-runtime) (allowing a maximum hash size of 512 mb)

### How to Use

- [Fork](https://github.com/RaviharaV-bot/hyper-stockfish/fork) this repository.
- Install [Heroku CLI](https://devcenter.heroku.com/articles/heroku-cli) and [create a new app](https://dashboard.heroku.com/new-app) in Heroku. <br/>
**Do note that in certain operating systems Heroku CLI doesn't get added to path automatically. If that's the case you'll have to add heroku to your path manually.**
- Run this command in cmd or powershell `heroku stack:set container -a appname`, where `appname` is replaced with your Heroku app's name.- Create a [new heroku app](https://dashboard.heroku.com/new-app).
- Open the `Settings` tab on heroku and insert your [API access token with `bot:play` scopes enabled](https://lichess.org/account/oauth/token/create?scopes[]=bot:play&description=Lichess+Bot+Token) in the `Config vars` field in the format `LICHESS_BOT_TOKEN:API-ACCESS-TOKEN`, where you replace `API-ACCESS-TOKEN` with your API Access token.
- Go to the `Deploy` tab and click `Connect to GitHub`.
- Click on `search` and then select your fork of this repository.
- Then `Enable Automatic Deploys` and then select the `main` branch (which is already done by default usually) and Click `Deploy`.
- Once it has been deployed, go to `Resources` tab on heroku and enable dynos. (Do note that if you don't see any dynos in the `Resources` tab, then you must wait for about 5 minutes and then refresh your heroku page.)

You're now connected to lichess and awaiting challenges! Your bot is up and ready!
