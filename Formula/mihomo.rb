# This file is updated by .github/scripts/update-mihomo.rb.
class Mihomo < Formula
  desc "Rule-based proxy with Smart Groups (vernesong Alpha build)"
  homepage "https://github.com/vernesong/mihomo"
  version "2026.10.05.034932"
  license "GPL-3.0-or-later"

  livecheck do
    skip "Rolling prerelease: updated by .github/scripts/update-mihomo.rb"
  end

  depends_on :macos

  on_macos do
    on_arm do
      url "https://github.com/vernesong/mihomo/releases/download/Prerelease-Alpha/mihomo-darwin-arm64-alpha-smart-70ef6d8.gz"
      sha256 "a5af9587e9eef517bb555e190e2d0dbfadb01dd464eb1e25a4cd733ace0f32ea"
    end

    on_intel do
      url "https://github.com/vernesong/mihomo/releases/download/Prerelease-Alpha/mihomo-darwin-amd64-compatible-alpha-smart-70ef6d8.gz"
      sha256 "719487374cf72964630f1678ed674146ed7800382ba544d3fd89027ea55c715e"
    end
  end

  def install
    bin.install Dir["mihomo-darwin-*"].first => "mihomo"
    (etc/"mihomo").mkpath
    (var/"lib/mihomo").mkpath
  end

  def caveats
    <<~EOS
      Before starting the service, create your configuration file at:
        #{etc}/mihomo/config.yaml

      Runtime data is stored in:
        #{var}/lib/mihomo
    EOS
  end

  service do
    run [opt_bin/"mihomo", "-d", var/"lib/mihomo", "-f", etc/"mihomo/config.yaml"]
    run_type :immediate
    keep_alive true
  end

  test do
    assert_match "alpha-smart-70ef6d8", shell_output("#{bin}/mihomo -v")

    (testpath/"config.yaml").write <<~YAML
      mode: rule
      rules:
        - MATCH,DIRECT
    YAML
    assert_match "test is successful",
                 shell_output("#{bin}/mihomo -t -d #{testpath} -f #{testpath}/config.yaml")
  end
end
