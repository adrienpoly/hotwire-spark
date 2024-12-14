# Configure Rails Environment
ENV["RAILS_ENV"] = "test"

require_relative "../test/dummy/config/environment"
ActiveRecord::Migrator.migrations_paths = [ File.expand_path("../test/dummy/db/migrate", __dir__) ]
ActiveRecord::Migrator.migrations_paths << File.expand_path("../db/migrate", __dir__)
require "rails/test_help"

# Load fixtures from the engine
if ActiveSupport::TestCase.respond_to?(:fixture_paths=)
  ActiveSupport::TestCase.fixture_paths = [ File.expand_path("fixtures", __dir__) ]
  ActionDispatch::IntegrationTest.fixture_paths = ActiveSupport::TestCase.fixture_paths
  ActiveSupport::TestCase.file_fixture_path = File.expand_path("fixtures", __dir__) + "/files"
  ActiveSupport::TestCase.fixtures :all
end

require "helpers/files_helper"

class ActiveSupport::TestCase
  include FilesHelper

  setup do
    reload_rails_reloader
    ActionCable.server.suppress_restarts = true
  end

  teardown do
    ActionCable.server.suppress_restarts = false
  end

  private
    def reload_rails_reloader
      Rails.application.reloader.reload!
    end

    def wait_for_hotwire_spark
      assert_css "[data-hotwire-spark-ready]"
    end
end
