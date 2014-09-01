#
# Cookbook Name::       zookeeper
# Description::         Base configuration for zookeeper
# Recipe::              default
# Author::              Chris Howe - Infochimps, Inc
#
# Copyright 2010, Infochimps, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

include_recipe 'volumes'
include_recipe 'silverware'
include_recipe 'java'       ; complain_if_not_sun_java(:zookeeper)

#
# User
#
daemon_user(:zookeeper) do
  home          node[:zookeeper][:home_dir]
  manage_home   false
end

#
# Configuration files
#
standard_dirs('zookeeper.server') do
  directories   :conf_dir
end

# Zookeeper log storage on a single scratch dir
volume_dirs('zookeeper.log') do
  type          :local
  selects       :single
  path          'zookeeper/log'
  group         'zookeeper'
  mode          "0777"
end

link '/var/log/zookeeper' do
  to node[:zookeeper][:log_dir]

  # FIXME: This is a bit of a hack. We're seeing a collision here
  # possibly caused by pig/hadoop living on the same machine. For now,
  # this should resolve that issue.
  not_if { ::File.exists? '/var/log/zookeeper' }
end
