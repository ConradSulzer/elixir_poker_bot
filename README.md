# Poker
A Slack bot for pokering GitHub issues!

### DEMO
Join the bot sandbox slack to demo live: https://join.slack.com/t/bot-sandbox-corp/shared_invite/zt-16ef9rods-nU6nn43jNJAL5BfbT4Nzgw.

Use `/poker help` to see available commands. There is currently only one valid issue in the connected repo, issue 1.

## Running The Bot

The first thing you will need to do is create a poker bot app, install it to your workspace and add it to a channel. Find out about Slack basic app setup [here](https://api.slack.com/authentication/basics#installing). The app might not use all of the following permissions, but it definitely uses some of them. So, you're gonna want to add these:

`channels:join`
`chat:write`
`chat:write.customize`
`commands`
`incoming-webhook`
`reactions:write`
`users:read`

To start your Phoenix server:

- Install dependencies with `mix deps.get`.
- Create a `dev_secrets.exs` file in your `config` folder. It should have the following:

```
config :poker,
  slack_signing_secret: "your slack signing secret",
  slack_version: "v0",
  slack_bot_oauth_token: "your slack bot oauth token",
  slack_base_url: "https://slack.com/api",
  github_access_token: "your github access token",
  github_api_url: "https://api.github.com",
  github_issue_path: "/repos/<your org>/<your repo>/issues/"
```

- Start Phoenix endpoint with `mix phx.server` or inside IEx with `iex -S mix phx.server`.

Communicate with Slack:

- Go to your [Slack apps](https://api.slack.com/apps) and choose your poker bot app or create a new one!
- From the app dashbaord go to "Slash Commands" and create a new command called `/poker`.
- For the Request URL add your URL with the path `/api/slash` appended to it.
  - Ex. `http://a934-75-213-459-95.ngrok.io/api/slash`
- If you are developing locally you can use [`ngrok`](https://ngrok.com/) to expose your `localhost` to the dangers of the web!
- Save that and then go to "Interactivity & Shortcuts".
- Turn on "Interactivity"!
- For the "Request URL" do the same as above except the path is going to be `/api/interactive`.
  - Ex. `http://a934-75-213-459-95.ngrok.io/api/interactive`
