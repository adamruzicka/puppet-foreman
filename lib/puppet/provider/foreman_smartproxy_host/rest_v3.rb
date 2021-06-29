Puppet::Type.type(:foreman_smartproxy_host).provide(:rest_v3, :parent => Puppet::Type.type(:foreman_host).provider(:rest_v3)) do
  confine :feature => [:json, :oauth]

  def exists?
    return false if host.nil? || proxy.nil?

    host['smart_proxy_id'] == proxy_id
  end

  def create
    if host.nil?
      error_string = "Host #{resource[:name]} does not exist in Foreman at #{request_uri('')}"
      raise Puppet::Error.new(error_string)
    end

    if proxy.nil?
      error_string = "Proxy #{resource[:name]} does not exist in Foreman at #{request_uri('')}"
      raise Puppet::Error.new(error_string)
    end

    path = "api/v2/smart_proxies/#{proxy_id}/hosts/#{id}"
    r = request(:put, path, {})

    unless success?(r)
      error_string = "Error making PUT request to Foreman at #{request_uri(path)}: #{error_message(r)}"
      raise Puppet::Error.new(error_string)
    end
  end

  def proxy
    @proxy ||= begin
      path = 'api/v2/smart_proxies'
      r = request(:get, path, :search => %{name="#{resource[:name]}"})

      unless success?(r)
        error_string = "Error making GET request to Foreman at #{request_uri(path)}: #{error_message(r)}"
        raise Puppet::Error.new(error_string)
      end

      JSON.load(r.body)['results'][0]
    end
  end

  def proxy_id
    proxy['id'] if proxy
  end

  def host_id
    host['host_id'] if host
  end

  private

  def destroy_path
    "api/v2/smart_proxies/#{proxy_id}/hosts/#{host_id}"
  end
end
