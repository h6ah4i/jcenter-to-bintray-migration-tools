require 'open-uri'
require 'oga'
require 'pry'

ARG_TARGET_REPO = ARGV[0]

def recursively_content_list(url)
  uri = URI.parse(url)
  dest = []

  if !url.end_with?('/')
    dest.push(url)
    return dest
  end

  URI.open(uri) do |content|
    html = content.read
    doc = Oga.parse_html(html)

    STDERR.puts "DIR: #{uri}"

    child_urls = doc.css('a')
      .map { |node| node.attr(:href).value }
      .map { |entry| entry.gsub(':', '/') }
      .map { |c| File.join(url, c) }

    child_urls.each do |child|
      recursively_content_list(child).each do |f|
        dest.push(f)
      end
    end
  end

  dest
end

list = recursively_content_list(File.join(ARG_TARGET_REPO, '/'))

puts list.join("\n")
