defmodule GoogleDriveUploader.MixProject do
  use Mix.Project

  def project do
    [
      app: :google_drive_uploader,
      version: "0.1.0",
      elixir: "~> 1.14",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      mod: {OliversGoogleDriveUploader.Application, []},
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:google_apis, git: "https://github.com/googleapis/elixir-google-api"},
      {:google_api_drive, "~> 0.25.1"},
      {:csv, "~> 3.2"},
      {:goth, "~> 1.3.0"},
      {:oauth2, "~> 0.9"}
    ]
  end
end
