#!/usr/bin/env ruby

require "digest"
require "json"
require "net/http"
require "time"
require "uri"

FORMULA_PATH = File.expand_path("../../Formula/mihomo.rb", __dir__)

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

uri = URI("https://api.github.com/repos/vernesong/mihomo/commits/Prerelease-Alpha")
token = ENV["GITHUB_TOKEN"] || ENV["GH_TOKEN"]
commit = JSON.parse(github_get(uri, token: token)).fetch("sha")
abort "Invalid source commit" unless commit.match?(/\A[0-9a-f]{40}\z/)

source_url = "https://github.com/vernesong/mihomo/archive/#{commit}.tar.gz"
content = File.read(FORMULA_PATH)
if content.include?("url \"#{source_url}\"")
  puts "mihomo is already at alpha-smart-#{commit[0, 7]}"
  exit
end

# Date-based versions advance only when the published Alpha source commit changes.
version = Time.now.utc.strftime("%Y.%m.%d.%H%M%S")
source_digest = Digest::SHA256.hexdigest(github_get(URI(source_url)))
abort "Missing source URL" unless content.sub!(/url "[^"]+"/, "url \"#{source_url}\"")
abort "Missing source SHA256" unless content.sub!(/sha256 "[0-9a-f]{64}"/, "sha256 \"#{source_digest}\"")
abort "Missing source version" unless content.sub!(/version "[^"]+"/, "version \"#{version}\"")
abort "Missing source build version" unless content.sub!(
  /constant\.Version=alpha-smart-[0-9a-f]+/, "constant.Version=alpha-smart-#{commit[0, 7]}"
)
abort "Missing source test version" unless content.sub!(
  /assert_match "alpha-smart-[0-9a-f]+"/, "assert_match \"alpha-smart-#{commit[0, 7]}\""
)
content.sub!(/^  revision \d+\n/, "")

# Complete all network requests and validation before updating the formula.
File.write(FORMULA_PATH, content)
puts "Updated mihomo to #{version} (alpha-smart-#{commit[0, 7]})"
