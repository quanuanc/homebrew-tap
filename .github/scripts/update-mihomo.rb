#!/usr/bin/env ruby

require "digest"
require "json"
require "net/http"
require "time"
require "uri"

FORMULA_PATH = File.expand_path("../../Formula/mihomo.rb", __dir__)
SOURCE_FORMULA_PATH = File.expand_path("../../Formula/mihomo-source.rb", __dir__)

def github_get(uri, token: nil, redirects: 5)
  request = Net::HTTP::Get.new(uri)
  request["Accept"] = "application/vnd.github+json"
  request["X-GitHub-Api-Version"] = "2022-11-28"
  request["Authorization"] = "Bearer #{token}" if uri.host == "api.github.com" && token && !token.empty?

  response = Net::HTTP.start(uri.host, uri.port, use_ssl: true) { |http| http.request(request) }
  if response.is_a?(Net::HTTPRedirection)
    abort "Too many redirects for #{uri}" if redirects.zero?

    return github_get(URI.join(uri, response.fetch("location")), token: token, redirects: redirects - 1)
  end
  abort "GitHub request failed: #{response.code} #{response.message}" unless response.is_a?(Net::HTTPSuccess)

  response.body
end

uri = URI("https://api.github.com/repos/vernesong/mihomo/releases/tags/Prerelease-Alpha")
token = ENV["GITHUB_TOKEN"] || ENV["GH_TOKEN"]
release = JSON.parse(github_get(uri, token: token))
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

# Resolve the asset commit rather than the moving Alpha branch or prerelease tag.
commit_uri = URI("https://api.github.com/repos/vernesong/mihomo/commits/#{commits.first}")
commit = JSON.parse(github_get(commit_uri, token: token)).fetch("sha")
abort "Invalid source commit" unless commit.match?(/\A[0-9a-f]{40}\z/) && commit.start_with?(commits.first)

source_url = "https://github.com/vernesong/mihomo/archive/#{commit}.tar.gz"
source_content = File.read(SOURCE_FORMULA_PATH)
unless source_content.include?("url \"#{source_url}\"")
  source_digest = Digest::SHA256.hexdigest(github_get(URI(source_url)))
  abort "Missing source URL" unless source_content.sub!(/url "[^"]+"/, "url \"#{source_url}\"")
  abort "Missing source SHA256" unless source_content.sub!(/sha256 "[0-9a-f]{64}"/, "sha256 \"#{source_digest}\"")
end
abort "Missing source version" unless source_content.sub!(/version "[^"]+"/, "version \"#{version}\"")
abort "Missing source build version" unless source_content.sub!(
  /constant\.Version=alpha-smart-[0-9a-f]+/, "constant.Version=alpha-smart-#{commits.first}"
)
abort "Missing source test version" unless source_content.sub!(
  /assert_match "alpha-smart-[0-9a-f]+"/, "assert_match \"alpha-smart-#{commits.first}\""
)

# Complete all network requests and validation before writing either formula.
File.write(FORMULA_PATH, content)
File.write(SOURCE_FORMULA_PATH, source_content)
puts "Updated mihomo and mihomo-source to #{version} (alpha-smart-#{commits.first})"
