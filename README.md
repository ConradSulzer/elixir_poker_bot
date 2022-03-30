# Poker

The first thing you will need to do is create a poker bot app, install it to your workspace and add it to a channel. Find out about Slack basic app setup [`here](https://api.slack.com/authentication/basics#installing). Your app will need the following permissions:

channels:join
chat:write
chat:write.customize
commands
incoming-webhook
reactions:write
users:read

## Running Locally

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

- Start up `ngrok` with `ngrok http 3000` (Get [`ngrok`](https://ngrok.com/)).
- You should get an HTTP and HTTPS forwarding address. You will need either one of these in a minute.
- Go to your [`Slack apps`](https://api.slack.com/apps) and choose your poker bot app or create a new one!
- From the app dashbaord go to "Slash Commands" and create a new command called `/poker`.
- For the Request URL use the `ngrok` forwarding address with the path `/api/slash`.
  Ex. `http://a934-75-213-459-95.ngrok.io/api/slash`
- Save that and then go to "Interactivity & Shortcuts".
- Turn on "Interactivity"!
- For the "Request URL" do the same as above except the path is going to be `/api/interactive`.
  Ex. `http://a934-75-213-459-95.ngrok.io/api/interactive`

## Learn more

- Official website: https://www.phoenixframework.org/
- Guides: https://hexdocs.pm/phoenix/overview.html
- Docs: https://hexdocs.pm/phoenix
- Forum: https://elixirforum.com/c/phoenix-forum
- Source: https://github.com/phoenixframework/phoenix
