# frozen_string_literal: true

module TemplateLoader
  def self.load_templates(path)
    YAML.load_file(Rails.root.join('lib', 'game_content', path)).deep_symbolize_keys
  rescue Errno::ENOENT
    raise ArgumentError, "Template file not found: #{path}"
  end
end
