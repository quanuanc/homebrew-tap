
cask "trae" do
  version "1.0.5760"
  sha256 "cb175d226b832d688a99443f89063cb093e3e9192068eec520bdcfe97e22bc0a"

  url "https://lf-trae.toscdn.com/obj/trae-ai-cn/pkg/app/releases/stable/#{version}/darwin/Trae-darwin-arm64.dmg"
  name "Trae"
  desc "Trae is an adaptive AI IDE that transforms how you work, collaborating with you to run faster."
  homepage "https://www.trae.ai/home"

  app "Trae.app"
  
  auto_updates true

  uninstall quit: "com.trae.app"

end
