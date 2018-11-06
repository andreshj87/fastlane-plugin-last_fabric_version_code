require 'fastlane/action'
require_relative '../helper/last_fabric_version_code_helper'

module Fastlane
  module Actions
    class LastFabricVersionCodeAction < Action
      def self.run(params)
        auth_url = "https://fabric.io/oauth/token"
        auth_body='{"grant_type":"password","scope":"apps beta","username":"' + params[:username] + '","password":"' + params[:password] + '","client_id":"2c18f8a77609ee6bbac9e53f3768fedc45fb96be0dbcb41defa706dc57d9c931","client_secret":"092ed1cdde336647b13d44178932cba10911577faf0eda894896188a7d900cc9"}'
        auth_uri = URI.parse(auth_url)
        auth_http = Net::HTTP.new(auth_uri.host, auth_uri.port)
        auth_http.use_ssl = true
        auth_request = Net::HTTP::Post.new(auth_uri.request_uri)
        auth_request.add_field('Content-Type', 'application/json')
        auth_request.body = auth_body
        auth_response = auth_http.request(auth_request)
        auth_response_parsed = JSON.parse(auth_response.body)
        auth_token = auth_response_parsed['access_token']

        organization_id = ''
        app_id = ''

        apps_url = "https://fabric.io/api/v2/apps"
        apps_uri = URI.parse(apps_url)
        apps_http = Net::HTTP.new(apps_uri.host, apps_uri.port)
        apps_http.use_ssl = true
        apps_request = Net::HTTP::Get.new(apps_uri.request_uri)
        apps_request.add_field('Authorization', 'Bearer ' + auth_token)
        apps_response = apps_http.request(apps_request)
        apps_parsed = JSON.parse(apps_response.body)
        apps_parsed.map do |app|
          if app['bundle_identifier'].casecmp(params[:app_package]).zero?
            if params.has_key?(:platform)
                if app['platform'].casecmp(params[:platform]).zero?
                  organization_id = app['organization_id']
                  app_id = app['id']
                end
            else
              organization_id = app['organization_id']
              app_id = app['id']
            end
          end
        end

        builds_url = "https://fabric.io/api/v2/organizations/#{organization_id}/apps/#{app_id}/beta_distribution/releases"
        builds_uri = URI.parse(builds_url)
        builds_http = Net::HTTP.new(builds_uri.host, builds_uri.port)
        builds_http.use_ssl = true
        builds_request = Net::HTTP::Get.new(builds_uri.request_uri)
        builds_request.add_field('Authorization', 'Bearer ' + auth_token)
        builds_response = builds_http.request(builds_request)
        builds_parsed = JSON.parse(builds_response.body)
        last_version_code = builds_parsed['instances'][0]['build_version']['build_version']

        UI.message("Last Fabric version code: #{last_version_code}")

        return last_version_code.to_i
      end

      def self.description
        "Get the last Fabric version code for your Android app"
      end

      def self.authors
        ["Andrés Hernández"]
      end

      def self.return_value
        "The last Fabric version code"
      end

      def self.details
        # Optional:
        "Get the last Fabric version code for your Android app"
      end

      def self.available_options
        [
          FastlaneCore::ConfigItem.new(key: :username,
                                      description: "Your Fabric username",
                                      optional: false,
                                      type: String),
          FastlaneCore::ConfigItem.new(key: :password,
                                      description: "Your Fabric password",
                                      optional: false,
                                      type: String),
          FastlaneCore::ConfigItem.new(key: :app_package,
                                      description: "Your Fabric app package",
                                      optional: false,
                                      type: String)
        ]
      end

      def self.is_supported?(platform)
        [:android].include?(platform)
      end
    end
  end
end
