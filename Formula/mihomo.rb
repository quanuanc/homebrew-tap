# This file is updated by .github/scripts/update-mihomo.rb.
class Mihomo < Formula
  desc "Rule-based proxy with Smart Groups (vernesong Alpha build)"
  homepage "https://github.com/vernesong/mihomo"
  version "2026.10.05.064044"
  license "GPL-3.0-or-later"

  livecheck do
    skip "Rolling prerelease: updated by .github/scripts/update-mihomo.rb"
  end

  depends_on :macos

  on_macos do
    on_arm do
      url "https://github.com/vernesong/mihomo/releases/download/Prerelease-Alpha/mihomo-darwin-arm64-alpha-smart-512b09d.gz"
      sha256 "8c5d72cc421099ad156dec7f4e6f844ea0a014e37ff0af1d258e180d099c9970"
    end

    on_intel do
      url "https://github.com/vernesong/mihomo/releases/download/Prerelease-Alpha/mihomo-darwin-amd64-compatible-alpha-smart-512b09d.gz"
      sha256 "195b7e78351614ed60ff39d9c434d9d00d7a1545d92e851f217c2a03ab4a9a72"
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
    assert_match "alpha-smart-512b09d", shell_output("#{bin}/mihomo -v")

    (testpath/"config.yaml").write <<~YAML
      mode: rule
      rules:
        - MATCH,DIRECT
    YAML
    assert_match "test is successful",
                 shell_output("#{bin}/mihomo -t -d #{testpath} -f #{testpath}/config.yaml")
  end
end
