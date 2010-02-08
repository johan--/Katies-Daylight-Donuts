namespace :db do
  
  desc "Bootstrapping database (users, deliveries, buy_backs, customers, employees, items)."
  task :bootstrap => :environment do
    ENV['FIXTURES_DIR'] = ""
    Rake::Task["backported:db:fixtures:load"].invoke
  end
  
end

namespace :backported do
  
  # Backported from http://github.com/rails/rails/commit/697ee1a50dea7580a7240535d3ad89d2d090721a (actually my commit :)
  namespace :db do
    namespace :fixtures do
      desc "Load fixtures into the current environment's database.  Load specific fixtures using FIXTURES=x,y. Load from subdirectory in spec/fixtures using FIXTURES_DIR=z."
      task :load => :environment do
        require 'active_record/fixtures'
        ActiveRecord::Base.establish_connection(Rails.env)
        base_dir = File.join(Rails.root, 'spec', 'fixtures')
        fixtures_dir = ENV['FIXTURES_DIR'] ? File.join(base_dir, ENV['FIXTURES_DIR']) : base_dir

        (ENV['FIXTURES'] ? ENV['FIXTURES'].split(/,/).map {|f| File.join(fixtures_dir, f) } : Dir.glob(File.join(fixtures_dir, '*.{yml,csv}'))).each do |fixture_file|
          Fixtures.create_fixtures(File.dirname(fixture_file), File.basename(fixture_file, '.*'))
        end
      end

      desc "Search for a fixture given a LABEL or ID."
      task :identify => :environment do
        require "active_record/fixtures"

        label, id = ENV["LABEL"], ENV["ID"]
        raise "LABEL or ID required" if label.blank? && id.blank?

        puts %Q(The fixture ID for "#{label}" is #{Fixtures.identify(label)}.) if label

        Dir["#{RAILS_ROOT}/spec/fixtures/**/*.yml"].each do |file|
          if data = YAML::load(ERB.new(IO.read(file)).result)
            data.keys.each do |key|
              key_id = Fixtures.identify(key)

              if key == label || key_id == id.to_i
                puts "#{file}: #{key} (#{key_id})"
              end
            end
          end
        end
      end
    end
  end
  
end
