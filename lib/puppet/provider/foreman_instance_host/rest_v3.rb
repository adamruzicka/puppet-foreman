Puppet::Type.type(:foreman_instance_host).provide(:rest_v3, :parent => Puppet::Type.type(:foreman_host).provider(:rest_v3)) do
  confine :feature => [:json, :oauth]

  def exists?
    return false if host.nil?

    host['foreman']
  end

  def create
    if host.nil?
      error_string = "Host #{resource[:name]} does not exist in Foreman at #{request_uri('')}"
      raise Puppet::Error.new(error_string)
    end

    path = "api/v2/instance/hosts/#{resource[:name]}"
    r = request(:put, path, {})

    unless success?(r)
      error_string = "Error making PUT request to Foreman at #{request_uri(path)}: #{error_message(r)}"
      raise Puppet::Error.new(error_string)
    end
  end

  private

  def destroy_path
    "api/v2/instance/hosts/#{resource[:name]}"
  end
end
