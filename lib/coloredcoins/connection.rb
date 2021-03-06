# frozen_string_literal: true

require 'rest-client'

module Coloredcoins
  class Connection
    attr_reader :url

    def initialize(url = nil)
      @url = url
    end

    def get(path, payload = {})
      query :get, path, payload
    end

    def post(path, payload = {})
      query :post, path, payload
    end

    def query(method, path, payload = {}) # rubocop:disable Metrics/MethodLength
      uri = endpoint_uri(path)
      response = RestClient::Request.execute(
        method: method,
        url: uri,
        payload: payload.to_json,
        ssl_version: 'SSLv23',
        headers: {
          content_type: :json,
          accept: :json
        }
      )
      JSON.parse(response, symbolize_names: true)
    rescue RestClient::ExceptionWithResponse => e
      raise Coloredcoins::ConnectionError, e.response
    end

  private

    def endpoint_uri(path = '')
      "#{@url}/#{path.gsub(%r{^\/}, '')}"
    end
  end
end
