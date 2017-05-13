require 'lib/base'
require 'lib/category'

require 'fileutils'
require 'yaml'

class Entry < Base
  attr_accessor :id, :base_name, :text, :text_more, :title, :created_on

  def self.find_all
    @_entries ||= begin
      sql = <<~SQL
        select
          entry_id as id
          , entry_basename as base_name
          , entry_text as text
          , entry_text_more as text_more
          , entry_title as title
          , entry_created_on as created_on
        from
          mt_entry
      SQL
      client.query(sql).map do |res|
        self.new(
          id: res['id'],
          base_name: res['base_name'],
          text: res['text'],
          text_more: res['text_more'],
          title: res['title'],
          created_on: res['created_on']
        )
      end
    end
  end

  def initialize(id:, base_name:, text:, text_more:, title:, created_on:)
    @id = id
    @base_name = base_name
    @text = text
    @text_more = text_more
    @title = title
    @created_on = created_on
  end

  def categories
    @_categories ||= begin
      sql = <<~SQL
       select
         c.category_label as label
         , c.category_basename as basement
       from
         mt_entry e
           inner join mt_placement p on e.entry_id = p.placement_entry_id
           inner join mt_category c on p.placement_category_id = c.category_id
       where
         e.entry_id = #{id}
      SQL
      Base.client.query(sql).map do |res|
        Category.new(
          label: res['label'],
          basement: res['basement'],
        )
      end
    end
  end

  def year
    created_on.year
  end

  def month
    created_on.month
  end

  def day
    created_on.day
  end

  def build_dir
    "#{Base.build_dir}/#{year}/#{format('%02d', month)}/#{format('%02d', day)}"
  end

  def has_build_dir?
    Dir.exists?(build_dir)
  end

  def make_build_dir!
    FileUtils.mkdir_p(build_dir)
  end

  def build_path
    "#{build_dir}/#{base_name}.html.markdown"
  end

  def build_meta_data
    {
      "title" => title,
      "date" => "#{year}/#{format('%02d', month)}/#{format('%02d', day)}",
      "categories" => categories.map(&:label).join(', '),
      "published" => true,
    }
  end

  def build_body
    [text, text_more].join("\n\n")
  end

  def export!
    text = <<~TEXT
      #{build_meta_data.to_yaml}
      ---

      #{build_body}
    TEXT

    File.open(build_path, 'w') do |f|
      f.puts(text)
    end
  end
end
