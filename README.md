# GoogleDriveUploader

An elixir utility to help me upload files to google drive in bulk

## Setup

1. Copy .envrc.sample to .envrc, fill out values. Client secret and client ID should be taken from an OAuth configuration you need to set up.
2. Copy service account key `client-secret.json` into top level of directory. This is used by goth.
3. Run `mix google_apis.auth https://www.googleapis.com/auth/drive` to retrieve your access token (will take you through oauth flow)
   3b. Copy verification code from the `code` param in the redirect URL and paste it into the CLI prompt.
   3c. Copy the access token value that you are then given.
4. `iex -S mix`

```
conn = GoogleApi.Drive.V3.Connection.new(<ACCESS TOKEN GOES HERE>)

{:ok, %_{files: files}} = GoogleApi.Drive.V3.Api.Files.drive_files_list(conn)

files |> Enum.map(&(Map.get(&1, :name)))
```
