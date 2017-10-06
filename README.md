RPMBUILD for consul
=========================

Consul and Consul-template rpm

How to Build
=========
    git clone https://github.com/allanhung/rpm_consul
    cd rpm_consul
    docker run --name=consul_build --rm -ti -v $(pwd)/rpms:/root/rpmbuild/RPMS/x86_64 -v $(pwd)/rpms:/root/rpmbuild/RPMS/noarch -v $(pwd)/scripts:/usr/local/src/build centos /bin/bash -c "/usr/local/src/build/build_consul.sh 0.9.3 0.19.3"

# check
    docker run --name=consul_check --rm -ti -v $(pwd)/rpms:/root/rpmbuild/RPMS centos /bin/bash -c "yum localinstall -y /root/rpmbuild/RPMS/consul-*.rpm"


Reference
=========
[consul-rpm](https://github.com/tomhillable/consul-rpm)
