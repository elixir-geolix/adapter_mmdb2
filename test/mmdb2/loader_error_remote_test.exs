defmodule Geolix.Adapter.MMDB2.LoaderErrorRemoteTest do
  use ExUnit.Case, async: true

  import ExUnit.CaptureLog

  alias Geolix.Adapter.MMDB2

  defmodule InetsHandler do
    require Record

    Record.defrecord(:mod, Record.extract(:mod, from_lib: "inets/include/httpd.hrl"))

    def unquote(:do)(mod_data), do: serve_uri(mod(mod_data, :request_uri), mod_data)

    defp serve_uri(~c"/error-status", _mod_data) do
      body = ~c""

      head = [
        code: 500,
        content_length: body |> length() |> Kernel.to_charlist(),
        content_type: ~c"text/plain"
      ]

      {:proceed, [{:response, {:response, head, body}}]}
    end
  end

  setup_all do
    Application.ensure_all_started(:inets)

    root = String.to_charlist(__DIR__)

    httpd_config = [
      document_root: root,
      modules: [InetsHandler],
      port: 0,
      server_name: ~c"geolix_loader_error_remote_test",
      server_root: root
    ]

    {:ok, httpd_pid} = :inets.start(:httpd, httpd_config)

    on_exit(fn ->
      :inets.stop(:httpd, httpd_pid)
    end)

    [test_host: "http://localhost:#{:httpd.info(httpd_pid)[:port]}"]
  end

  test "non 200 response from remote source", %{test_host: test_host} do
    db = %{
      id: :loader_remote_error,
      adapter: MMDB2,
      source: "#{test_host}/error-status"
    }

    log =
      capture_log(fn ->
        assert {:error, {:remote, {:status, 500}}} = Geolix.load_database(db)
      end)

    assert log =~ "Failed to read remote for database :loader_remote_error"
  end
end
