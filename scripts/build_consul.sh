CONSULVER=${1:-'0.9.3'}
RPMVER="${CONSULVER/-/_}"
CONSULTEMPVER=${2:-'0.19.3'}
RPMTEMPVER="${CONSULTEMPVER/-/_}"
export RPMBUILDROOT=/root/rpmbuild
export GOPATH=/usr/share/gocode
export PATH=$GOPATH/bin:$PATH

# go repo
rpm --import https://mirror.go-repo.io/centos/RPM-GPG-KEY-GO-REPO
curl -s https://mirror.go-repo.io/centos/go-repo.repo | tee /etc/yum.repos.d/go-repo.repo
# epel
yum install -y epel-release
yum -y install golang git bzip2 rpm-build make which gcc-c++ ruby-devel rubygem-bundler
mkdir -p $RPMBUILDROOT/SOURCES && mkdir -p $RPMBUILDROOT/SPECS && mkdir -p $RPMBUILDROOT/SRPMS
# fix rpm marcos
sed -i -e "s#.centos##g" /etc/rpm/macros.dist

# consul
mkdir -p $GOPATH/src/github.com/hashicorp
cd $GOPATH/src/github.com/hashicorp
git clone --depth=10 -b v$CONSULVER https://github.com/hashicorp/consul.git

# build web ui
make tools
cd $GOPATH/src/github.com/hashicorp/consul/ui
bundle
make dist
cd $GOPATH/src/github.com/hashicorp/consul
make static-assets
# build consul
cd $GOPATH/src/github.com/hashicorp/consul
make dev

/bin/cp -f /usr/local/src/build/consul.service $RPMBUILDROOT/SOURCES/
/bin/cp -f /usr/local/src/build/consul.sysconfig $RPMBUILDROOT/SOURCES/
/bin/cp -f /usr/local/src/build/consul.json $RPMBUILDROOT/SOURCES/
/bin/cp -f /usr/local/src/build/consul.spec $RPMBUILDROOT/SPECS/

rpmbuild -bb $RPMBUILDROOT/SPECS/consul.spec --define "_version $RPMVER"

# consul-template
mkdir -p $GOPATH/src/github.com/hashicorp
cd $GOPATH/src/github.com/hashicorp
git clone --depth=10 -b v$CONSULTEMPVER https://github.com/hashicorp/consul-template.git

# build consul-template
cd $GOPATH/src/github.com/hashicorp/consul-template
make dev

/bin/cp -f /usr/local/src/build/consul-template.service $RPMBUILDROOT/SOURCES/
/bin/cp -f /usr/local/src/build/consul-template.sysconfig $RPMBUILDROOT/SOURCES/
/bin/cp -f /usr/local/src/build/consul-template.json $RPMBUILDROOT/SOURCES/
/bin/cp -f /usr/local/src/build/consul-template.spec $RPMBUILDROOT/SPECS/

rpmbuild -bb $RPMBUILDROOT/SPECS/consul-template.spec --define "_version $RPMTEMPVER"
