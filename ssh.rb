# don't forget adding net-ssh to Gemfil

require 'net/ssh'

keyfile = File.expand_path("~/.ssh/id_rsa_vvz")
host = 'i08fs1.ira.uka.de'
user = 's_baumst'
local_forwards = {
  8765 => ['kim-cm-bts01.scc.kit.edu', 80],
}

Net::SSH.start(host, user, :keys => [keyfile]) do |ssh|
  local_forwards.each do |local_port, (remote_host, remote_port)|
    ssh.forward.local(local_port, remote_host, remote_port)
    ssh.loop { true }
  end
end
