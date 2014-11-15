module Scrapespeare
  class CLI < Thor

    desc "yaml FILE_PATH URI", "Run scraper against URI and return YAML"
    def yaml(file_path, uri)
      require "yaml"

      puts scraper_from_file(file_path)
        .scrape(uri)
        .to_yaml
    end

    desc "json FILE_PATH URI", "Run scraper against URI and return YAML"
    def json(file_path, uri)
      require "json"

      puts scraper_from_file(file_path)
        .scrape(uri)
        .to_json
    end

  private

    # Returns and initializes a Scraper by evaluating the file content in its instance context
    #
    # @param file_path [String]
    # @return [Scrapespeare::Scraper]
    def scraper_from_file(file_path)
      file_content = read_file(file_path)
      Scraper.new { eval(file_content) }
    end

    # Returns the content of a file
    #
    # @param file_path [String]
    # @return [String]
    def read_file(file_path)
      IO.read(file_path)
    end

  end
end