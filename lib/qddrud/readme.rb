require 'chef/cookbook/metadata'
require 'erb'

module Drud
  # Constructs a new ERB object for rendering a Readme.md file.
  class ReadmeTemplate < OpenStruct
    # Desribe the behaviour of the method
    #
    # ==== Attributes
    #
    # * +:template+ - The template to render against.
    #
    # ==== Examples
    # Assuming this is the content of template.erb:
    #    My metadata is <%= metadata %>
    # You would render it with the following:
    #    markdown = ReadmeTemplate.new(metadata: @metadata)
    #    markdown.render(File.read('template.erb'))
    def render(template)
      ERB.new(template).result(binding)
    end
  end
  # Evaluates an opscode chef cookbook's
  # {metadata}[http://docs.opscode.com/essentials_cookbook_metadata.html] and
  # {github}[https://github.com/] history to generate a README.md file. The
  # README.rb is placed in the root level of the cookbook. This forces cookbook
  # developers to properly use metadata to document their cookbooks
  # efficiently.  Additionally, it provides proper attribution for all
  # committers in the project with links back to the contributors github
  # profile. It is written to take advantage of cookbooks that properly utilize
  # both Rake tasks and metadata.
  class Readme
    # Hash map of all site cookbooks including metadata
    attr_accessor :cookbooks

    # Path to the site-cookbooks
    attr_accessor :path
  
    # Initialize a new instance of Drud::Readme
    #
    # ==== Attributes
    #
    # * +:path+ - The local path of the site cookbooks
    #
    # ==== Examples
    # This can be placed in a convenient location, such as a Rake task inside
    # the cookbook. When the render method is called, it will overwrite the
    # cookbooks README.md
    #    readme = Drud::Readme.new(File.dirname(__FILE__))
    #    readme.render
    def initialize(path)
      @path = File.expand_path(path)
      @cookbooks = load_cookbooks
    end

    # Renders the README.md file and saves it in the cookbooks path.
    def render
      markdown = ReadmeTemplate.new(
        metadata: @metadata, tasks: @tasks, credit: @credit
      )
      template_path = File.join(
        File.dirname(File.expand_path(__FILE__)),
        '../../templates/readme.md.erb'
      )
      readme = markdown.render(File.read(template_path))
      File.open("#{@cookbook}/README.md", 'w') { |file| file.write(readme) }
    end

    private
    # Generates a hash of all site cookbook metadata by cookbook folder name
    def load_cookbooks # :doc:
      _cookbooks = Hash.new

      Dir.glob(File.join(@path, '*/*.rb')).each do |cb_metadata|
        cb_path = File.dirname(cb_metadata)
        cb_name = File.basename(cb_path)
        _cookbooks[cb_name] = [
          'path' => cb_path,
          'metadata' => load_metadata(cb_metadata)
        ]
      end

      _cookbooks
    end

    # Reads the cookbooks metadata and instantiates an instance of
    # Chef::Cookbook::Metadata
    def load_metadata(cb_metadata) # :doc:
      metadata = Chef::Cookbook::Metadata.new
      metadata.from_file(cb_metadata)
      metadata
    end
  end
end
