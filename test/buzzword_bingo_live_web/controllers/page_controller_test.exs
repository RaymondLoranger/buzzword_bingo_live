defmodule Buzzword.Bingo.LiveWeb.PageControllerTest do
  use Buzzword.Bingo.LiveWeb.ConnCase

  test "GET /", %{conn: conn} do
    conn = get(conn, ~p"/home")

    assert html_response(conn, 200) =~
             "Peace of mind from prototype to production"
  end
end
