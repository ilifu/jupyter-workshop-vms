workshop_servers:
  hosts:
%{ for index, node in workshop_servers ~}
    ${ node.name }:
      ansible_host: ${ floating_ips[index].address }
      private_ip: ${ node.network[0].fixed_ip_v4 }
      workshop_users:
%{ for user_count in range(1, users_per_server + 1) ~}
        - username: ${ format("user%02s", index * users_per_server + user_count ) }
          password: ${ passwords[index * users_per_server + user_count - 1] }
%{ endfor ~}
%{ endfor ~}
  vars:
    ansible_connection: ssh
    ansible_ssh_common_args: '-o StrictHostKeyChecking=no -o ControlPersist=15m -i ${ ssh_public_key }'
    ansible_user: ubuntu
    admin_users:
%{ for user in admin_users ~}
      - username: ${ user.username }
        ssh_key: ${ user.public_key }
%{ endfor ~}
    cromwell_install: true
    docker_install: true
    jupyter_install: false
    singularity_install: true
    nextflow_install: true
    biotools_install: true
