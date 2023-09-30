import Config

config :google_apis, :oauth_client, System.get_env("GOOGLE_CLIENT_ID")
config :google_apis, :oauth_secret, System.get_env("GOOGLE_CLIENT_SECRET")

config :goth,
  json: "#{File.cwd!()}/client-secret.json" |> File.read!()
