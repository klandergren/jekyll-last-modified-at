module Jekyll
  module LastModifiedAt
    class Git
      attr_reader :site_source

      def initialize(site_source)
        @site_source = site_source
        @is_git_repo = nil
      end

      def top_level_directory
        return nil unless is_git_repo?
        @top_level_directory ||= begin
          Dir.chdir(@site_source) do
            top_level_directory = File.join(Executor.sh("git", "rev-parse", "--show-toplevel"), ".git")
          end
        rescue
          ""
        end
      end

      def is_git_repo?
        return @is_git_repo unless @is_git_repo.nil?
        @is_git_repo = begin
          Dir.chdir(@site_source) do
            Executor.sh("git", "rev-parse", "--is-inside-work-tree").eql? "true"
          end
        rescue
          false
        end
      end

    end
  end
end
