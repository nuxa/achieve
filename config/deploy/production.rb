server '52.197.252.97', user: 'app', roles: %w{app db web}
set :ssh_options, keys: '/Users/horieiji/.ssh/id_rsa.pub'
