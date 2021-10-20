Puppet::Type.newtype(:foreman_smartproxy_host) do
  desc 'foreman_smartproxy_host marks a host as a smart proxy.'

  instance_eval(&PuppetX::Foreman::Common::FOREMAN_HOST_PARAMS)

  autorequire(:foreman_smartproxy) do
    [self[:name]]
  end
end
