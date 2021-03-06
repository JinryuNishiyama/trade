module FillOutFormModule
  def fill_out(game, action)
    within ".game-form" do
      fill_in "ゲーム名", with: game.name
      select "交換", from: "掲示板の用途"
      fill_in "掲示板の説明", with: game.description
      click_on action == "new" ? "作成" : "更新"
    end
  end
end
