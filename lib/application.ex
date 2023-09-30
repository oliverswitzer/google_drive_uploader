defmodule OliversGoogleDriveUploader.Application do
  use Application

  def start(_type, _args) do
    children = [
      {Goth, name: OliversGoogleDriveUploader.Goth}
    ]

    Supervisor.start_link(children, strategy: :one_for_one)
  end
end
