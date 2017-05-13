require 'yaml'
require 'mysql2'

class Base
  def self.config
    @_config ||= YAML.load_file("./config.yml")
  end

  def self.client
    @_client ||= begin
      config = Base.config['db']
      ::Mysql2::Client.new(
        host: config['host'],
        username: config['user'],
        password: config['password'],
        encoding: config['encoding'],
        database: config['database'],
      )
    end
  end

  def self.build_dir
    Base.config['build']
  end
end
