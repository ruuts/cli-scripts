#!/usr/bin/env ruby

LOCALE_1 = ARGV[0]
LOCALE_2 = ARGV[1]

require 'yaml'

def flatten_keys(hash, prefix="")
  keys = []
  hash.keys.each do |key|
    if hash[key].is_a? Hash
      current_prefix = prefix + "#{key}."
      keys << flatten_keys(hash[key], current_prefix)
    else
      keys << "#{prefix}#{key}"
    end
  end
  prefix == "" ? keys.flatten : keys
end

def compare(locale_1, locale_2)
  yaml_1 = YAML.load(File.open(File.expand_path(locale_1)))
  yaml_2 = YAML.load(File.open(File.expand_path(locale_2)))

  keys_1 = flatten_keys(yaml_1[yaml_1.keys.first])
  keys_2 = flatten_keys(yaml_2[yaml_2.keys.first])

  missing = keys_2 - keys_1
  file = locale_1.split('/').last
  if missing.any?
    puts "Missing from #{file}:"
    missing.each { |key| puts "  - #{key}" }
  else
    puts "Nothing missing from #{file}."
  end
end

compare(LOCALE_1, LOCALE_2)
puts
compare(LOCALE_2, LOCALE_1)
