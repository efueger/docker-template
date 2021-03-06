# Frozen-string-literal: true
# Copyright: 2015 Jordon Bedwell - Apache v2.0 License
# Encoding: utf-8

require "json"
require "yaml"

module Docker
  module Template

    # Configuration is a global version of meatadata, where anything
    # that can be set on configuration can be optimized and stored globally
    # in a opts.{json,yml} file in the current working directory.

    class Config
      extend Forwardable

      def_delegator :@config, :keys
      def_delegator :@config, :to_h
      def_delegator :@config, :to_enum
      def_delegator :@config, :has_key?
      def_delegator :@config, :each
      def_delegator :@config, :[]

      Defaults = {
        "type" => "simple",
        "user" => "envygeeks",
        "local_prefix" => "local",
        "rootfs_base_img" => "envygeeks/ubuntu:tiny",
        "maintainer" => "Jordon Bedwell <jordon@envygeeks.io>",
        "dockerhub_copy" => false,
        "repos_dir" => "repos",
        "copy_dir" => "copy",
        "tag" => "latest",

        "aliases" => {},
           "pkgs" => { "tag" => {}, "type" => {}, "all" => nil },
        "entries" => { "tag" => {}, "type" => {}, "all" => nil },
       "releases" => { "tag" => {}, "type" => {}, "all" => nil },
       "versions" => { "tag" => {}, "type" => {}, "all" => nil },
            "env" => { "tag" => {}, "type" => {}, "all" => nil },
           "tags" => {}
      }.freeze

      EmptyDefaults = {
        "tags" => { "latest" => "normal" }
      }

      #

      def initialize
        @config = Defaults.deep_merge(read_config_from)
        @config = @config.merge(EmptyDefaults) do |key, oval, nval|
          oval.nil? || oval.empty?? nval : oval
        end

        @config.freeze
      end

      # Allows you to read a configuration file from a root and get back
      # either the parsed data or a blank hash that can be merged the way you
      # wish to merge it (if you even care to merge it.)

      def read_config_from(dir = Docker::Template.root)
        file = Dir[dir.join("*.{json,yml}")].first
        return {} unless file && (file = Pathname.new(file)).file?
        return JSON.parse(file.read).stringify if file.extname == ".json"
        YAML.load_file(file).stringify
      end

      #

      def has_default?(key)
        return @config.has_key?(key)
      end

      #

      def build_types
        return @build_types ||= %W(simple scratch).freeze
      end
    end
  end
end
