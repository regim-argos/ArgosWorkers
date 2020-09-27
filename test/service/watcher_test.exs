defmodule ArgosWorkersTest do
  use ExUnit.Case, async: true
  doctest Service.Watcher

  import Mox

  setup :verify_on_exit!

  describe "Watcher entity" do
    test "Should return true if has same delay and active true" do
      assert Service.Watcher.hasNotChange(%{delay: 10, active: true}, %{delay: 10, active: true}) === true
    end

    test "Should return false if has different delay" do
      assert Service.Watcher.hasNotChange(%{delay: 10, active: true}, %{delay: 20, active: true}) === false
    end


    test "Should return false if has active false" do
      assert Service.Watcher.hasNotChange(%{delay: 10, active: true}, %{delay: 10, active: false}) === false
    end

    test "Should measure a time of function" do
      {ms, _result} = Service.Watcher.measure(fn -> :timer.sleep(1000) end)
      assert ms >= 1000
    end

    test "get watcher by cache" do
      expected_value = %Service.Watcher{
        active: true,
        delay: 10,
        id: 1,
        last_change: "2020-08-17T02:20:50Z",
        name: "Argos",
        notifications: [%{id: 4}, %{id: 5}],
        project_id: 1,
        status: true,
        url: "https://projectargos.tech/"
      }
      ArgosWorkers.Infra.MockRedis
      |> expect(:get, fn (_key) ->
        {:ok, Poison.encode!(expected_value)}
      end)

      ArgosWorkers.Infra.Repo.MockWatcherRepo
      |> expect(:getById, 0, fn (_id, _project_id) ->
        expected_value
      end)

      assert Service.Watcher.getById(1,1) === expected_value
    end

    test "get by db" do
      expected_value = %Service.Watcher{
        active: true,
        delay: 10,
        id: 1,
        last_change: "2020-08-17T02:20:50Z",
        name: "Argos",
        notifications: [%{id: 4}, %{id: 5}],
        project_id: 1,
        status: true,
        url: "https://projectargos.tech/"
      }

      ArgosWorkers.Infra.MockRedis
      |> expect(:get, fn (_key) ->
        {:ok, nil}
      end)

      |> expect(:set, fn (_key, _value) ->
        nil
      end)

      ArgosWorkers.Infra.Repo.MockWatcherRepo
      |> expect(:getById, 1, fn (_id, _project_id) ->
        expected_value
      end)

      assert Service.Watcher.getById(1,1) === expected_value
    end

    test "should verify a true status" do
      watcher = %Service.Watcher{
        url: "https://projectargos.tech/"
      }
      ArgosWorkers.Infra.MockHttp
      |> expect(:get, fn (_key) ->
        %{status_code: 200}
      end)
      {status, _} = Service.Watcher.verifyStatus(watcher)
      assert status === true
    end

    test "should verify a false status" do
      watcher = %Service.Watcher{
        url: "https://projectargos.tech/"
      }
      ArgosWorkers.Infra.MockHttp
      |> expect(:get, fn (_key) ->
        %{status_code: 400}
      end)
      {status, _} = Service.Watcher.verifyStatus(watcher)
      assert status === false
    end
  end
end
