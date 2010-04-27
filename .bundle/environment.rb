# DO NOT MODIFY THIS FILE
# Generated by Bundler 0.9.24

require 'digest/sha1'
require 'yaml'
require 'pathname'
require 'rubygems'
Gem.source_index # ensure Rubygems is fully loaded in Ruby 1.9

module Gem
  class Dependency
    if !instance_methods.map { |m| m.to_s }.include?("requirement")
      def requirement
        version_requirements
      end
    end
  end
end

module Bundler
  class Specification < Gem::Specification
    attr_accessor :relative_loaded_from

    def self.from_gemspec(gemspec)
      spec = allocate
      gemspec.instance_variables.each do |ivar|
        spec.instance_variable_set(ivar, gemspec.instance_variable_get(ivar))
      end
      spec
    end

    def loaded_from
      return super unless relative_loaded_from
      source.path.join(relative_loaded_from).to_s
    end

    def full_gem_path
      Pathname.new(loaded_from).dirname.expand_path.to_s
    end
  end

  module SharedHelpers
    attr_accessor :gem_loaded

    def default_gemfile
      gemfile = find_gemfile
      gemfile or raise GemfileNotFound, "Could not locate Gemfile"
      Pathname.new(gemfile)
    end

    def in_bundle?
      find_gemfile
    end

    def env_file
      default_gemfile.dirname.join(".bundle/environment.rb")
    end

  private

    def find_gemfile
      return ENV['BUNDLE_GEMFILE'] if ENV['BUNDLE_GEMFILE']

      previous = nil
      current  = File.expand_path(Dir.pwd)

      until !File.directory?(current) || current == previous
        filename = File.join(current, 'Gemfile')
        return filename if File.file?(filename)
        current, previous = File.expand_path("..", current), current
      end
    end

    def clean_load_path
      # handle 1.9 where system gems are always on the load path
      if defined?(::Gem)
        me = File.expand_path("../../", __FILE__)
        $LOAD_PATH.reject! do |p|
          next if File.expand_path(p).include?(me)
          p != File.dirname(__FILE__) &&
            Gem.path.any? { |gp| p.include?(gp) }
        end
        $LOAD_PATH.uniq!
      end
    end

    def reverse_rubygems_kernel_mixin
      # Disable rubygems' gem activation system
      ::Kernel.class_eval do
        if private_method_defined?(:gem_original_require)
          alias rubygems_require require
          alias require gem_original_require
        end

        undef gem
      end
    end

    def cripple_rubygems(specs)
      reverse_rubygems_kernel_mixin

      executables = specs.map { |s| s.executables }.flatten
      Gem.source_index # ensure RubyGems is fully loaded

     ::Kernel.class_eval do
        private
        def gem(*) ; end
      end

      ::Kernel.send(:define_method, :gem) do |dep, *reqs|
        if executables.include? File.basename(caller.first.split(':').first)
          return
        end
        opts = reqs.last.is_a?(Hash) ? reqs.pop : {}

        unless dep.respond_to?(:name) && dep.respond_to?(:requirement)
          dep = Gem::Dependency.new(dep, reqs)
        end

        spec = specs.find  { |s| s.name == dep.name }

        if spec.nil?
          e = Gem::LoadError.new "#{dep.name} is not part of the bundle. Add it to Gemfile."
          e.name = dep.name
          e.version_requirement = dep.requirement
          raise e
        elsif dep !~ spec
          e = Gem::LoadError.new "can't activate #{dep}, already activated #{spec.full_name}. " \
                                 "Make sure all dependencies are added to Gemfile."
          e.name = dep.name
          e.version_requirement = dep.requirement
          raise e
        end

        true
      end

      # === Following hacks are to improve on the generated bin wrappers ===

      # Yeah, talk about a hack
      source_index_class = (class << Gem::SourceIndex ; self ; end)
      source_index_class.send(:define_method, :from_gems_in) do |*args|
        source_index = Gem::SourceIndex.new
        source_index.spec_dirs = *args
        source_index.add_specs(*specs)
        source_index
      end

      # OMG more hacks
      gem_class = (class << Gem ; self ; end)
      gem_class.send(:define_method, :bin_path) do |name, *args|
        exec_name, *reqs = args

        spec = nil

        if exec_name
          spec = specs.find { |s| s.executables.include?(exec_name) }
          spec or raise Gem::Exception, "can't find executable #{exec_name}"
        else
          spec = specs.find  { |s| s.name == name }
          exec_name = spec.default_executable or raise Gem::Exception, "no default executable for #{spec.full_name}"
        end

        gem_bin = File.join(spec.full_gem_path, spec.bindir, exec_name)
        gem_from_path_bin = File.join(File.dirname(spec.loaded_from), spec.bindir, exec_name)
        File.exist?(gem_bin) ? gem_bin : gem_from_path_bin
      end
    end

    extend self
  end
end

module Bundler
  ENV_LOADED   = true
  LOCKED_BY    = '0.9.24'
  FINGERPRINT  = "f5e8f156b6d1c95b4906b0b8e4419fb59a200659"
  HOME         = '/Users/yvesvanbroeckhoven/.bundle/ruby/1.8/bundler'
  AUTOREQUIRES = {:default=>[["authlogic", false], ["cucumber", false], ["factory_girl", false], ["haml", false], ["shoulda", false], ["will_paginate", false]]}
  SPECS        = [
        {:loaded_from=>"/opt/local/lib/ruby/gems/1.8/specifications/activesupport-2.3.5.gemspec", :load_paths=>["/opt/local/lib/ruby/gems/1.8/gems/activesupport-2.3.5/lib"], :name=>"activesupport"},
        {:loaded_from=>"/opt/local/lib/ruby/gems/1.8/specifications/authlogic-2.1.3.gemspec", :load_paths=>["/opt/local/lib/ruby/gems/1.8/gems/authlogic-2.1.3/lib"], :name=>"authlogic"},
        {:loaded_from=>"/opt/local/lib/ruby/gems/1.8/specifications/builder-2.1.2.gemspec", :load_paths=>["/opt/local/lib/ruby/gems/1.8/gems/builder-2.1.2/lib"], :name=>"builder"},
        {:loaded_from=>"/opt/local/lib/ruby/gems/1.8/specifications/diff-lcs-1.1.2.gemspec", :load_paths=>["/opt/local/lib/ruby/gems/1.8/gems/diff-lcs-1.1.2/lib"], :name=>"diff-lcs"},
        {:loaded_from=>"/opt/local/lib/ruby/gems/1.8/specifications/json_pure-1.2.4.gemspec", :load_paths=>["/opt/local/lib/ruby/gems/1.8/gems/json_pure-1.2.4/lib"], :name=>"json_pure"},
        {:loaded_from=>"/opt/local/lib/ruby/gems/1.8/specifications/polyglot-0.3.1.gemspec", :load_paths=>["/opt/local/lib/ruby/gems/1.8/gems/polyglot-0.3.1/lib"], :name=>"polyglot"},
        {:loaded_from=>"/opt/local/lib/ruby/gems/1.8/specifications/term-ansicolor-1.0.5.gemspec", :load_paths=>["/opt/local/lib/ruby/gems/1.8/gems/term-ansicolor-1.0.5/lib"], :name=>"term-ansicolor"},
        {:loaded_from=>"/opt/local/lib/ruby/gems/1.8/specifications/treetop-1.4.5.gemspec", :load_paths=>["/opt/local/lib/ruby/gems/1.8/gems/treetop-1.4.5/lib"], :name=>"treetop"},
        {:loaded_from=>"/opt/local/lib/ruby/gems/1.8/specifications/cucumber-0.6.4.gemspec", :load_paths=>["/opt/local/lib/ruby/gems/1.8/gems/cucumber-0.6.4/lib"], :name=>"cucumber"},
        {:loaded_from=>"/opt/local/lib/ruby/gems/1.8/specifications/factory_girl-1.2.4.gemspec", :load_paths=>["/opt/local/lib/ruby/gems/1.8/gems/factory_girl-1.2.4/lib"], :name=>"factory_girl"},
        {:loaded_from=>"/opt/local/lib/ruby/gems/1.8/specifications/haml-2.2.22.gemspec", :load_paths=>["/opt/local/lib/ruby/gems/1.8/gems/haml-2.2.22/lib"], :name=>"haml"},
        {:loaded_from=>"/opt/local/lib/ruby/gems/1.8/specifications/shoulda-2.10.3.gemspec", :load_paths=>["/opt/local/lib/ruby/gems/1.8/gems/shoulda-2.10.3/lib"], :name=>"shoulda"},
        {:loaded_from=>"/opt/local/lib/ruby/gems/1.8/specifications/will_paginate-2.3.12.gemspec", :load_paths=>["/opt/local/lib/ruby/gems/1.8/gems/will_paginate-2.3.12/lib"], :name=>"will_paginate"},
      ].map do |hash|
    if hash[:virtual_spec]
      spec = eval(hash[:virtual_spec], TOPLEVEL_BINDING, "<virtual spec for '#{hash[:name]}'>")
    else
      dir = File.dirname(hash[:loaded_from])
      spec = Dir.chdir(dir){ eval(File.read(hash[:loaded_from]), TOPLEVEL_BINDING, hash[:loaded_from]) }
    end
    spec.loaded_from = hash[:loaded_from]
    spec.require_paths = hash[:load_paths]
    if spec.loaded_from.include?(HOME)
      Bundler::Specification.from_gemspec(spec)
    else
      spec
    end
  end

  extend SharedHelpers

  def self.configure_gem_path_and_home(specs)
    # Fix paths, so that Gem.source_index and such will work
    paths = specs.map{|s| s.installation_path }
    paths.flatten!; paths.compact!; paths.uniq!; paths.reject!{|p| p.empty? }
    ENV['GEM_PATH'] = paths.join(File::PATH_SEPARATOR)
    ENV['GEM_HOME'] = paths.first
    Gem.clear_paths
  end

  def self.match_fingerprint
    lockfile = File.expand_path('../../Gemfile.lock', __FILE__)
    lock_print = YAML.load(File.read(lockfile))["hash"] if File.exist?(lockfile)
    gem_print = Digest::SHA1.hexdigest(File.read(File.expand_path('../../Gemfile', __FILE__)))

    unless gem_print == lock_print
      abort 'Gemfile changed since you last locked. Please run `bundle lock` to relock.'
    end

    unless gem_print == FINGERPRINT
      abort 'Your bundled environment is out of date. Run `bundle install` to regenerate it.'
    end
  end

  def self.setup(*groups)
    match_fingerprint
    clean_load_path
    cripple_rubygems(SPECS)
    configure_gem_path_and_home(SPECS)
    SPECS.each do |spec|
      Gem.loaded_specs[spec.name] = spec
      spec.require_paths.each do |path|
        $LOAD_PATH.unshift(path) unless $LOAD_PATH.include?(path)
      end
    end
    self
  end

  def self.require(*groups)
    groups = [:default] if groups.empty?
    groups.each do |group|
      (AUTOREQUIRES[group.to_sym] || []).each do |file, explicit|
        if explicit
          Kernel.require file
        else
          begin
            Kernel.require file
          rescue LoadError
          end
        end
      end
    end
  end

  # Set up load paths unless this file is being loaded after the Bundler gem
  setup unless defined?(Bundler::GEM_LOADED)
end