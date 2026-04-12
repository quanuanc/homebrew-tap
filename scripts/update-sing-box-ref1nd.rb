#!/usr/bin/env ruby

require "json"
require "net/http"
require "uri"

RELEASES_REPO = "reF1nd/sing-box-releases"
FORMULA_PATH = File.expand_path("../Formula/sing-box-ref1nd.rb", __dir__)
ASSET_SUFFIXES = [
  "darwin-arm64",
  "darwin-amd64",
  "linux-arm64-glibc",
  "linux-amd64-glibc",
].freeze

def github_get(path)
  uri = URI("https://api.github.com#{path}")
  request = Net::HTTP::Get.new(uri)
  request["Accept"] = "application/vnd.github+json"
  request["X-GitHub-Api-Version"] = "2022-11-28"

  token = ENV["GITHUB_TOKEN"] || ENV["GH_TOKEN"]
  request["Authorization"] = "Bearer #{token}" if token && !token.empty?

  Net::HTTP.start(uri.host, uri.port, use_ssl: true) do |http|
    response = http.request(request)
    return JSON.parse(response.body) if response.is_a?(Net::HTTPSuccess)

    abort <<~EOS
      GitHub API request failed: #{response.code} #{response.message}
      #{response.body}
    EOS
  end
end

def normalize_tag(tag)
  tag.start_with?("v") ? tag : "v#{tag}"
end

def find_release(releases, requested_tag)
  if requested_tag
    releases.find { |release| release["tag_name"] == normalize_tag(requested_tag) }
  else
    releases.find do |release|
      release["prerelease"] && release["tag_name"].match?(/^v\d+(?:\.\d+)+-alpha\.\d+-reF1nd$/)
    end
  end
end

def extract_sha256(asset)
  digest = asset["digest"].to_s
  return digest.delete_prefix("sha256:") if digest.start_with?("sha256:")

  abort "Missing sha256 digest for asset: #{asset["name"]}"
end

requested_tag = ARGV[0]
releases = github_get("/repos/#{RELEASES_REPO}/releases?per_page=50")
release = find_release(releases, requested_tag)

abort "Release not found: #{requested_tag}" if requested_tag && release.nil?
abort "No alpha release found in #{RELEASES_REPO}" if release.nil?

version = release.fetch("tag_name").delete_prefix("v")
sha256_by_suffix = ASSET_SUFFIXES.to_h do |suffix|
  asset_name = "sing-box-#{version}-#{suffix}.tar.gz"
  asset = release.fetch("assets").find { |item| item["name"] == asset_name }
  abort "Missing asset in release #{release["tag_name"]}: #{asset_name}" if asset.nil?

  [suffix, extract_sha256(asset)]
end

content = <<~'RUBY'
  # This file is updated by scripts/update-sing-box-ref1nd.rb.
  class SingBoxRef1nd < Formula
    desc "Universal proxy platform (reF1nd build)"
    homepage "https://github.com/reF1nd/sing-box-releases"
    version "__VERSION__"
    license "GPL-3.0-or-later"

    livecheck do
      url "https://github.com/reF1nd/sing-box-releases/releases"
      regex(/^v?(\d+(?:\.\d+)+-alpha\.\d+-reF1nd)$/i)
      strategy :github_releases
    end

    on_macos do
      on_arm do
        url "https://github.com/reF1nd/sing-box-releases/releases/download/v__VERSION__/sing-box-__VERSION__-darwin-arm64.tar.gz"
        sha256 "__DARWIN_ARM64_SHA256__"
      end

      on_intel do
        url "https://github.com/reF1nd/sing-box-releases/releases/download/v__VERSION__/sing-box-__VERSION__-darwin-amd64.tar.gz"
        sha256 "__DARWIN_AMD64_SHA256__"
      end
    end

    on_linux do
      on_arm do
        url "https://github.com/reF1nd/sing-box-releases/releases/download/v__VERSION__/sing-box-__VERSION__-linux-arm64-glibc.tar.gz"
        sha256 "__LINUX_ARM64_GLIBC_SHA256__"
      end

      on_intel do
        url "https://github.com/reF1nd/sing-box-releases/releases/download/v__VERSION__/sing-box-__VERSION__-linux-amd64-glibc.tar.gz"
        sha256 "__LINUX_AMD64_GLIBC_SHA256__"
      end
    end

    conflicts_with "sing-box", because: "both install a sing-box binary"

    def install
      binary = Dir["**/sing-box"].find { |path| File.file?(path) && File.executable?(path) }
      odie "sing-box binary not found in release archive" if binary.nil?

      bin.install binary => "sing-box"

      license_file = Dir["**/LICENSE"].find { |path| File.file?(path) }
      doc.install license_file if license_file
    end

    service do
      run [opt_bin/"sing-box", "run", "--config", etc/"sing-box/config.json", "--directory", var/"lib/sing-box"]
      run_type :immediate
      keep_alive true
    end

    test do
      assert_match version.to_s, shell_output("#{bin}/sing-box version")
    end
  end
RUBY

content = content
  .gsub("__VERSION__", version)
  .gsub("__DARWIN_ARM64_SHA256__", sha256_by_suffix.fetch("darwin-arm64"))
  .gsub("__DARWIN_AMD64_SHA256__", sha256_by_suffix.fetch("darwin-amd64"))
  .gsub("__LINUX_ARM64_GLIBC_SHA256__", sha256_by_suffix.fetch("linux-arm64-glibc"))
  .gsub("__LINUX_AMD64_GLIBC_SHA256__", sha256_by_suffix.fetch("linux-amd64-glibc"))

File.write(FORMULA_PATH, content)
puts "Updated #{FORMULA_PATH} to #{version}"
