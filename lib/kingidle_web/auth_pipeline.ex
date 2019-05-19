defmodule Kingidle.Guardian.AuthPipeline do
  use Guardian.Plug.Pipeline, otp_app: :Kingidle,
  module: Kingidle.Guardian,
  error_handler: Kingidle.AuthErrorHandler

  plug Guardian.Plug.VerifyHeader, realm: "Bearer"
  plug Guardian.Plug.EnsureAuthenticated
  plug Guardian.Plug.LoadResource
end
