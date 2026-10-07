# This file is updated by .github/scripts/update-mihomo.rb.
class Mihomo < Formula
  desc "Rule-based proxy with Smart Groups (vernesong Alpha build)"
  homepage "https://github.com/vernesong/mihomo"
  version "2026.10.06.040235"
  license "GPL-3.0-or-later"

  livecheck do
    skip "Rolling prerelease: updated by .github/scripts/update-mihomo.rb"
  end

  depends_on :macos

  on_macos do
    on_arm do
      url "https://github.com/vernesong/mihomo/releases/download/Prerelease-Alpha/mihomo-darwin-arm64-alpha-smart-c3b2cb5.gz"
      sha256 "1f2cb6939769ebff613c4b94a766eb7062f279ada0eb45ffc98d2e42635f4134"
    end

    on_intel do
      url "https://github.com/vernesong/mihomo/releases/download/Prerelease-Alpha/mihomo-darwin-amd64-compatible-alpha-smart-c3b2cb5.gz"
      sha256 "95ab7ae80adc7806f7d1eb165f3c0ea65a2d520513008c05880911dde2314222"
    end
  end

  conflicts_with "mihomo-source", because: "both install a mihomo binary"

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
    assert_match "alpha-smart-c3b2cb5", shell_output("#{bin}/mihomo -v")

    (testpath/"config.yaml").write <<~YAML
      mode: rule
      rules:
        - MATCH,DIRECT
    YAML
    assert_match "test is successful",
                 shell_output("#{bin}/mihomo -t -d #{testpath} -f #{testpath}/config.yaml")
  end
end
