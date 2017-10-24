defmodule Ueberauth.Strategy.Twitter.OAuthTest do
  use ExUnit.Case, async: true

  alias Ueberauth.Strategy.Twitter.OAuth

  setup do
    config = [consumer_key: "consumer_key", consumer_secret: "consumer_secret"]
    %{config: config}
  end

  test "access_token!/2: raises an appropriate error on auth failure", %{config: config} do
    assert_raise RuntimeError, ~r/401/i, fn ->
      OAuth.access_token! {"badtoken", "badsecret"}, "badverifier", config
    end
  end

  test "access_token!/2 raises an appropriate error on network failure", %{config: config} do
    assert_raise RuntimeError, ~r/nxdomain/i, fn ->
      OAuth.access_token! {"token", "secret"}, "verifier", Keyword.merge(config, site: "https://bogusapi.twitter.com")
    end
  end

  test "request_token!/2: raises an appropriate error on auth failure", %{config: config} do
    assert_raise RuntimeError, ~r/401/i, fn ->
      OAuth.request_token! [], Keyword.merge(config, redirect_uri: "some/uri")
    end
  end

  test "request_token!/2: raises an appropriate error on network failure", %{config: config} do
    assert_raise RuntimeError, ~r/nxdomain/i, fn ->
      OAuth.request_token! [], Keyword.merge(config, site: "https://bogusapi.twitter.com", redirect_uri: "some/uri")
    end
  end
end
