require 'json'
require 'net/http'
require 'openssl'
require 'base64'

module Qnap
	class DownloadStation
		PROTOCOL = 'https'
		APP_NAME = 'downloadstation'
		API_VERSION = 'V4'
		API_METHODS = {
			misc:    [:dir, :env, :login, :logout, :socks_5],
			task:    [:status, :query, :detail, :add_url, :add_torrent, :start, :stop, :pause, :remove, :priority, :get_file, :set_file],
			rss:     [:add, :query, :update, :remove, :query_feed, :update_feed, :add_job, :query_job, :update_job, :remove_job],
			config:  [:get, :set],
			account: [:add, :query, :update, :remove],
			addon:   [:query, :enable, :verify, :install, :uninstall, :search],
		}

		def self.session(*args)
			ds = self.new *args
			begin
				yield ds
			ensure
				ds.logout
			end
		end

		def logout
			return unless @sid

			data = misc_logout

			@sid = nil
			data
		end

		def misc_login(params={})
			# override the auto-gen method
			# otherwise `get_sid` is called
			despatch_query(uri_for_path(:misc, :login), params)
		end

		API_METHODS.each do |app, endpoints|
			endpoints.each do |endpoint|

				method_name = "#{app}_#{endpoint}".to_sym
				next if method_defined? method_name

				define_method method_name, Proc.new { |params={}|
					despatch_query(
						uri_for_path(app, endpoint),
						params.merge(sid: get_sid)
					)
				}
			end
		end

		def get_sid
			@sid ||= misc_login(user: @username, pass: Base64.encode64(@password))[:sid]
		end

		def initialize(host, username, password)
			@host     = host
			@username = username
			@password = password
			@sid      = nil
		end

		private

		def uri_for_path(app, endpoint)
			path = [app, endpoint].map { |s| s.to_s.gsub(/(^|_)(.)/){ $2.upcase } }.join "/"
			URI "#{PROTOCOL}://#{@host}/#{APP_NAME}/#{API_VERSION}/#{path}"
		end

		def despatch_query(uri, params)
			req = Net::HTTP::Post.new uri
			req.form_data = params

			response = Net::HTTP.start(
				uri.host,
				uri.port,
				use_ssl: PROTOCOL == 'https',
				verify_mode: OpenSSL::SSL::VERIFY_NONE
			) do |https|
				https.request req
			end

			data = JSON.parse response.read_body, symbolize_names: true

			if (data.key?(:error) and data[:error] > 0)
				raise RuntimeError.new "Error response from #{uri} -> #{data}"
			end

			data
		end
	end
end
