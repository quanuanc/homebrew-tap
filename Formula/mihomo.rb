# This file is updated by .github/scripts/update-mihomo.rb.
class Mihomo < Formula
  desc "Rule-based proxy with Smart Groups (vernesong Alpha build)"
  homepage "https://github.com/vernesong/mihomo"
  version "2026.10.01.043042"
  license "GPL-3.0-or-later"

  livecheck do
    skip "Rolling prerelease: updated by .github/scripts/update-mihomo.rb"
  end

  depends_on :macos

  on_macos do
    on_arm do
      url "https://github.com/vernesong/mihomo/releases/download/Prerelease-Alpha/mihomo-darwin-arm64-alpha-smart-baef5ee.gz"
      sha256 "a772e9be3a87ba24efdd3fd350d3d63126b0f1104f67088b1524f4f0476a5c09"
    end

    on_intel do
      url "https://github.com/vernesong/mihomo/releases/download/Prerelease-Alpha/mihomo-darwin-amd64-compatible-alpha-smart-baef5ee.gz"
      sha256 "f4c56bd1c7dd9b6b747628051a2400eded62ba0e7a8a064c69327e422979bb4d"
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
    assert_match "alpha-smart-baef5ee", shell_output("#{bin}/mihomo -v")

    (testpath/"config.yaml").write <<~YAML
      mode: rule
      rules:
        - MATCH,DIRECT
    YAML
    assert_match "test is successful",
                 shell_output("#{bin}/mihomo -t -d #{testpath} -f #{testpath}/config.yaml")
  end
end
