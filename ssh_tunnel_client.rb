# don't forget adding net-ssh to Gemfil

require 'net/ssh'

# the SSH private key file
keyfile = File.expand_path("~/.ssh/id_rsa_vvz")
# an ATIS shell boxs
host = 'i08fs1.ira.uka.de'
# my ATIS account name
user = 's_baumst'

# our local port forward
local_forwards = {
  8765 => ['kim-cm-bts01.scc.kit.edu', 80],
}

Net::SSH.start(host, user, :keys => [keyfile]) do |ssh|
  local_forwards.each do |local_port, (remote_host, remote_port)|
    ssh.forward.local(local_port, remote_host, remote_port)
    ssh.loop { true }
  end
end
