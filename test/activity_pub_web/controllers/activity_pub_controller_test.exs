defmodule ActivityPubWeb.ActivityPubControllerTest do
  use ActivityPubWeb.ConnCase

  import ActivityPub.Factory

  describe "object" do
    test "works for activities" do
      activity = insert(:note_activity)

      uuid =
        String.split(activity.data["id"], "/")
        |> List.last()

      resp =
        build_conn()
        |> put_req_header("accept", "application/json")
        |> get("/pub/objects/#{uuid}")
        |> json_response(200)

      assert resp["@context"]
      assert resp["type"] == "Create"
    end

    test "works for objects" do
      object = insert(:note)

      uuid =
        String.split(object.data["id"], "/")
        |> List.last()

      resp =
        build_conn()
        |> put_req_header("accept", "application/json")
        |> get("/pub/objects/#{uuid}")
        |> json_response(200)

      assert resp["@context"]
      assert resp["type"] == "Note"
    end
  end

  describe "actor" do
    test "works for actors" do
      actor = local_actor()

      resp =
        build_conn()
        |> put_req_header("accept", "application/json")
        |> get("pub/actors/#{actor.username}")
        |> json_response(200)

      assert resp["@context"]
      assert resp["preferredUsername"] == actor.username
      assert resp["url"] == resp["id"]
    end
  end
end
