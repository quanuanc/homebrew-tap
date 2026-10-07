# This file is updated by .github/scripts/update-mihomo.rb.
class Mihomo < Formula
  desc "Rule-based proxy with Smart Groups (built from source)"
  homepage "https://github.com/vernesong/mihomo"
  url "https://github.com/vernesong/mihomo/archive/c3b2cb5fdf868964c1fddd0ba58e1e070f19bf28.tar.gz"
  version "2026.10.06.040235"
  sha256 "926c0a4e1c1ce5960dd0f119110e2f561dd9570c3e4935e1c6e46c3e4129a8a6"
  license "GPL-3.0-or-later"
  revision 1

  livecheck do
    skip "Rolling prerelease: updated by .github/scripts/update-mihomo.rb"
  end

  depends_on "go" => :build
  depends_on :macos

  def fetch
    ENV["GOTOOLCHAIN"] = "local"
    system "go", "mod", "download"
  end

  def install
    ENV["CGO_ENABLED"] = "0"
    ENV["GOTOOLCHAIN"] = "local"
    ENV["GOPROXY"] = "off"
    ENV["GOSUMDB"] = "off"
    ldflags = %W[
      -X=github.com/metacubex/mihomo/constant.Version=alpha-smart-c3b2cb5
      -X=github.com/metacubex/mihomo/constant.BuildTime=#{time.iso8601}
      -B=gobuildid
    ]
    system "go", "build", *std_go_args(output: bin/"mihomo", ldflags:, tags: "with_gvisor")
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
    assert_match "LC_UUID", shell_output("/usr/bin/otool -l #{bin}/mihomo")

    (testpath/"config.yaml").write <<~YAML
      mode: rule
      rules:
        - MATCH,DIRECT
    YAML
    assert_match "test is successful",
                 shell_output("#{bin}/mihomo -t -d #{testpath} -f #{testpath}/config.yaml")
  end
end
