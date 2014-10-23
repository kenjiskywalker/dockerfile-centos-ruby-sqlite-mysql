FROM centos:centos6

MAINTAINER kenjiskywalker "https://github.com/kenjiskywalker/docker-centos-ruby-sqlite-mysql"

ENV RUBY_VERSION 2.1.3
ENV MYSQL_RPM_VERSION mysql-community-release-el6-5.noarch.rpm

### Packages
RUN yum groupinstall -y "Development tools"
RUN yum install -y openssl openssl-devel readline-devel readline compat-readline5 libxml2-devel libxslt-devel libyaml-devel git

### Install Ruby
RUN curl -O http://ftp.ruby-lang.org/pub/ruby/stable/ruby-$RUBY_VERSION.tar.gz
RUN tar zvxf ruby-$RUBY_VERSION.tar.gz
RUN cd ruby-$RUBY_VERSION && ./configure && make && make install

### Install bundler
RUN gem update --system
RUN gem install bundler --no-rdoc --no-ri

# Install sqlite
RUN yum install -y sqlite sqlite-devel

### add mysql user
RUN groupadd -r mysql && useradd -r -g mysql mysql

### MySQL install
RUN yum install -y http://repo.mysql.com/$MYSQL_RPM_VERSION
RUN yum install -y mysql-community-server mysql-community-devel

### https://github.com/docker-library/mysql

ENV MYSQL_ROOT_PASSWORD ''

COPY docker-entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
EXPOSE 3306
CMD ["mysqld", "--datadir=/var/lib/mysql", "--user=mysql"]
