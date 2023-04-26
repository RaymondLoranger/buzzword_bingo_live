defmodule Buzzword.Bingo.LiveWeb.ErrorJSONTest do
  use Buzzword.Bingo.LiveWeb.ConnCase, async: true

  test "renders 404" do
    assert Buzzword.Bingo.LiveWeb.ErrorJSON.render("404.json", %{}) == %{errors: %{detail: "Not Found"}}
  end

  test "renders 500" do
    assert Buzzword.Bingo.LiveWeb.ErrorJSON.render("500.json", %{}) ==
             %{errors: %{detail: "Internal Server Error"}}
  end
end
