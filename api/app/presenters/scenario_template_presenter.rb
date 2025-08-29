# frozen_string_literal: true

class ScenarioTemplatePresenter
  def self.all
    scenario_templates = TemplateLoader.load_templates('scenario_templates.yml')
    story_templates = TemplateLoader.load_templates('story_templates.yml')

    scenario_templates.map do |scenario_template_key, scenario_attrs|
      {
        key: scenario_template_key,
        title: scenario_attrs[:title],
        stories: story_templates.select do |_story_key, story_attrs|
          story_attrs[:scenario_template_key] == scenario_template_key.to_s
        end.map do |story_key, story_attrs|
          { key: story_key, title: story_attrs[:title] }
        end
      }
    end
  end
end
