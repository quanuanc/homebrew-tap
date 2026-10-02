#!/usr/bin/env ruby

require "json"
require "net/http"
require "time"
require "uri"

FORMULA_PATH = File.expand_path("../Formula/mihomo.rb", __dir__)
uri = URI("https://api.github.com/repos/vernesong/mihomo/releases/tags/Prerelease-Alpha")
request = Net::HTTP::Get.new(uri)
request["Accept"] = "application/vnd.github+json"
request["X-GitHub-Api-Version"] = "2022-11-28"
token = ENV["GITHUB_TOKEN"] || ENV["GH_TOKEN"]
request["Authorization"] = "Bearer #{token}" if token && !token.empty?

response = Net::HTTP.start(uri.host, uri.port, use_ssl: true) { |http| http.request(request) }
abort "GitHub API request failed: #{response.code} #{response.message}" unless response.is_a?(Net::HTTPSuccess)

release = JSON.parse(response.body)
assets = ["arm64", "amd64-compatible"].map do |arch|
  pattern = /\Amihomo-darwin-#{arch}-alpha-smart-([0-9a-f]+)\.gz\z/
  matches = release.fetch("assets").select { |asset| pattern.match?(asset.fetch("name")) }
  abort "Expected exactly one macOS #{arch} asset" unless matches.length == 1

  asset = matches.first
  digest = asset.fetch("digest", "").to_s
  abort "Missing SHA256 for #{asset.fetch("name")}" unless digest.match?(/\Asha256:[0-9a-f]{64}\z/)

  [asset, pattern.match(asset.fetch("name"))[1], digest.delete_prefix("sha256:")]
end

commits = assets.map { |_, commit, _| commit }.uniq
abort "macOS assets refer to different commits; release may still be uploading" unless commits.length == 1

# Numeric asset timestamps let brew upgrade order rolling Alpha builds correctly.
version = assets.map { |asset, _, _| Time.iso8601(asset.fetch("updated_at")) }.max.utc.strftime("%Y.%m.%d.%H%M%S")
content = File.read(FORMULA_PATH)
content.sub!(/version "[^"]+"/, "version \"#{version}\"")
assets.each do |asset, _, digest|
  arch = asset.fetch("name").include?("arm64") ? "arm64" : "amd64-compatible"
  pattern = %r{url "https://github.com/vernesong/mihomo/releases/download/Prerelease-Alpha/mihomo-darwin-#{arch}-[^\"]+"\n      sha256 "[0-9a-f]+"}
  abort "Missing formula URL for #{arch}" unless content.sub!(pattern, "url \"#{asset.fetch("browser_download_url")}\"\n      sha256 \"#{digest}\"")
end
content.sub!(/assert_match "alpha-smart-[0-9a-f]+"/, "assert_match \"alpha-smart-#{commits.first}\"")
File.write(FORMULA_PATH, content)
puts "Updated mihomo to #{version} (alpha-smart-#{commits.first})"
