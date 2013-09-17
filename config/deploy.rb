require 'nyulibraries/deploy/capistrano'

set :recipient, "getit.admin@nyu.edu"
set :app_title, "getit"

# Environments
set :stages, ["staging", "qa", "production"]


namespace :exlibris do
  namespace :aleph do
    desc "Refresh Aleph tables"
    task :refresh, :roles => :app do
      run "cd #{current_release} && RAILS_ENV=#{rails_env} bundle exec rake exlibris:aleph:refresh"
    end
  end
end
