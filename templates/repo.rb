# zammad repo file managed by puppet
# do not change
<% if @operatingsystem =~ /^(CentOS|RedHat)$/ %>
[zammad]
name=Repository for zammad/zammad application.
baseurl=https://rpm.packager.io/gh/zammad/zammad/centos7/<%= @branch %>
enabled=1
<% elsif @operatingsystem =~ /^Debian$/ %>
deb https://deb.packager.io/gh/zammad/zammad jessie <%= @branch %>
<% elsif @operatingsystem =~ /^(SLES|SUSE)$/ %>
[zammad]
name=Repository for zammad/zammad application.
baseurl=https://rpm.packager.io/gh/zammad/zammad/sles12/<%= @branch %>
enabled=1
<% elsif @operatingsystem =~ /^Ubuntu$/ %>
deb https://deb.packager.io/gh/zammad/zammad xenial <%= @branch %>
<% end %>
