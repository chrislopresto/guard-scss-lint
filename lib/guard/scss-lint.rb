require 'guard/compat/plugin'
require 'scss_lint'
require 'rainbow'
require 'rainbow/ext/string'

module Guard
  class ScssLint < Plugin
    require 'guard/scss-lint/version'

    def self.non_namespaced_name
      'scss-lint'
    end

    def initialize(options = {})
      super
      @options = {
        all_on_start: true,
        keep_failed: false
      }.merge(options)

      config_file = @options[:config] || '.scss-lint.yml'
      if File.exist?(config_file)
        @config     = SCSSLint::Config.load config_file
        @config_yml = YAML.load_file config_file
        @config_yml['exclude'].each { |e| @config.exclude_file e } if @config_yml['exclude']
      else
        @config = SCSSLint::Config.default
      end
      @scss_lint_runner = SCSSLint::Runner.new @config
      @failed_paths     = []
    end

    def start
      UI.info 'Guard::ScssLint is running'
      run_all if @options[:all_on_start]
    end

    def reload
      @failed_paths = []
    end

    def run_all
      UI.info 'Running ScssLint for all .scss files'
      pattern = File.join '**', '*.scss'
      paths   = Watcher.match_files(self, Dir.glob(pattern))
      run_on_changes paths
    end

    def run_on_changes(paths)
      paths << @failed_paths if @options[:keep_failed]
      run paths.uniq
    end

    private

    def run(paths = [])
      @scss_lint_runner = SCSSLint::Runner.new @config
      paths = paths.reject { |p| @config.excluded_file?(p) }
      @scss_lint_runner.run paths.map{|p| {path: p}}
      @scss_lint_runner.lints.each do |lint|
        UI.send lint.severity, lint_message(lint)
      end
      UI.info "Guard::ScssLint inspected #{paths.size} files, found #{@scss_lint_runner.lints.count} errors."
    end

    def lint_message(lint)
      [lint.filename.color(:cyan),
       ':',
       lint.location.line.to_s.color(:magenta),
       ':',
       lint.location.column.to_s.color(:blue),
       ' ',
       lint_severity_abbrevation(lint),
       ' ',
       lint.linter.name.color(:green),
       ':'.color(:green),
       ' ',
       lint.description
      ].join
    end

    def lint_severity_abbrevation(lint)
      color = lint.severity == :error ? :red : :yellow
      ['[', lint.severity.to_s[0].upcase, ']'].join.color(color)
    end
  end
end
