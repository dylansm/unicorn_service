require 'unicorn_service/utility'

require 'capistrano'
require 'capistrano/version'

module UnicornService
  class CapistranoIntegration

    TASKS = %w(unicorn_service:create_script unicorn_service:update_rc unicorn_service:start)


    def self.load_into(capistrano_config)

      capistrano_config.load do
        before(CapistranoIntegration::TASKS) do
          not_set =  []
          not_set << 'application' if fetch(:application, nil).nil?
          not_set << 'deploy_to'   if fetch(:deploy_to, nil).nil?
          not_set << 'user'        if fetch(:user, nil).nil?
          unless not_set.empty?
            fail "Necessary constants have not been initialized: #{not_set.inject(''){|s, item| s + "#{item}; " }}"
          end
        end

        extend Utility

        namespace :unicorn_service do
          desc 'Add script in /etc/init.d'
          task :create_script do
            put_sudo (create_initd_file deploy_to, user), "/etc/init.d/unicorn_#{deploy_env}.#{application}"
            run "#{sudo} chmod +x /etc/init.d/unicorn_#{deploy_env}.#{application}"
          end

          desc 'Update rc.d'
          task :update_rc do
            run "#{sudo} update-rc.d unicorn_#{deploy_env}.#{application} defaults"
          end

          desc 'Add to chkconfig'
          task :chkconfig_add do
            run "#{sudo} chkconfig --add unicorn_#{deploy_env}.#{application}"
            run "#{sudo} chkconfig unicorn_#{deploy_env}.#{application} on"
          end

          desc 'Remove from chkconfig'
          task :chkconfig_del do
            run "#{sudo} chkconfig unicorn_#{deploy_env}.#{application} off"
            run "#{sudo} chkconfig --del unicorn_#{deploy_env}.#{application}"
          end

          desc 'start chkconfig service'
          task :start_chkconfig do
            create_script
            chkconfig_add
          end

          desc 'start rc.d service'
          task :start_rc do
            create_script
            update_rc
          end
        end
      end
    end
  end
end

if Capistrano::Configuration.instance
  UnicornService::CapistranoIntegration.load_into(Capistrano::Configuration.instance)
end
