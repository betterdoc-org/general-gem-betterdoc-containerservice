module Betterdoc
  module Containerservice
    module Metadata

      def self.compute_name
        compute_name_from_environment || compute_name_from_file || compute_name_default || 'unknown'
      end

      def self.compute_name_from_environment
        ENV['SERVICE_NAME']
      end

      def self.compute_name_from_file
        name_file = File.expand_path(Rails.root.join('build', 'metadata', 'name'))
        File.read(name_file).strip if File.exist?(name_file)
      rescue StandardError
        nil
      end

      def self.compute_name_default
        nil
      end

      def self.compute_version
        compute_version_from_environment || compute_version_from_file || compute_version_default || "unknown"
      end

      def self.compute_version_from_environment
        ENV['SERVICE_VERSION'] unless ENV['SERVICE_VERSION'].blank?
      end

      def self.compute_version_from_file
        version_file = File.expand_path(Rails.root.join('build', 'metadata', 'version'))
        File.read(version_file).strip if File.exist?(version_file)
      rescue StandardError
        nil
      end

      def self.compute_version_default
        nil
      end

    end
  end
end
