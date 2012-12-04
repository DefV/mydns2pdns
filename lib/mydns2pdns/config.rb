class Mydns2PDNS
  class Config
    def initialize(config_path)
      @config = YAML.load_file(config_path) rescue {}
    end

    def method_missing(method, *arguments)
      @config[method.to_s]
    end
  end
end
