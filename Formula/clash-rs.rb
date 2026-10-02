# Rolling prerelease: update the version and checksums together when latest changes.
class ClashRs < Formula
  desc "Rule-based network proxy written in Rust (latest prerelease)"
  homepage "https://github.com/ibigbug/clash-rs"
  version "0.10.8-alpha+sha.39d06a4"
  license "Apache-2.0"

  livecheck do
    skip "Rolling prerelease: the latest tag and its assets are overwritten"
  end

  on_macos do
    on_arm do
      url "https://github.com/ibigbug/clash-rs/releases/download/latest/clash-rs-aarch64-apple-darwin"
      sha256 "deb4c2b828ce16b740f1d65efbf6553b5e3ca3624e16e04b3025e3ebfeee127a"
    end

    on_intel do
      url "https://github.com/ibigbug/clash-rs/releases/download/latest/clash-rs-x86_64-apple-darwin"
      sha256 "6c140f3f928252c4006daebf2445c4bf4b54a8a1110bb4fe1e2512cf070e0f72"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/ibigbug/clash-rs/releases/download/latest/clash-rs-aarch64-unknown-linux-musl"
      sha256 "4ea465a61175e5ee9be196cea5c8f2b1d01cfe0cc51227d9707c8426394a21df"
    end

    on_intel do
      url "https://github.com/ibigbug/clash-rs/releases/download/latest/clash-rs-x86_64-unknown-linux-musl"
      sha256 "1dc6dfa9135e4cdc72a5650af3f82933a7e8889008124b8a0e0b2ac92bfa566b"
    end
  end

  def install
    bin.install Dir["clash-rs-*"].first => "clash-rs"
    (etc/"clash-rs").mkpath
    (var/"lib/clash-rs").mkpath
  end

  def caveats
    <<~EOS
      Before starting the service, create your configuration file at:
        #{etc}/clash-rs/config.yaml

      Runtime data is stored in:
        #{var}/lib/clash-rs
    EOS
  end

  service do
    run [opt_bin/"clash-rs", "--directory", var/"lib/clash-rs", "--config", etc/"clash-rs/config.yaml"]
    run_type :immediate
    keep_alive true
  end

  test do
    assert_match "clash-rs #{version}", shell_output("#{bin}/clash-rs --version")

    (testpath/"config.yaml").write <<~YAML
      port: 7890
      mode: rule
      rules:
        - MATCH,DIRECT
    YAML
    assert_match "test is successful",
                 shell_output("#{bin}/clash-rs --test-config --directory #{testpath} --config config.yaml")
  end
end
