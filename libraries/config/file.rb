#
# Cookbook:: chef_auto_accumulator
# Library:: config_file
#
# Copyright:: Ben Hughes <bmhughes@bmhughes.co.uk>
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

require_relative '../_utils'
require_relative '../file'

module ChefAutoAccumulator
  module Config
    module File
      include ChefAutoAccumulator::File
      include ChefAutoAccumulator::Utils

      private

      # Load the on disk configuration file
      #
      # @param config_file [String] The configuration file to load
      # @return [Hash] Configuration file contents
      #
      def load_config_file(config_file)
        return unless ::File.exist?(config_file)

        load_file(config_file)
      end

      # Load a section from the on disk configuration file
      #
      # @param config_file [String] The configuration file to load
      # @return [Hash] Configuration file contents
      #
      def load_config_file_section(config_file)
        config = load_config_file(config_file)

        return if nil_or_empty?(config)

        path = resource_config_path
        section_config = config.dig(*path)
        Chef::Log.debug("load_config_file_section: #{config_file} section #{path.join('|')} - [#{section_config.class}] #{section_config}")

        section_config
      end

      # Load a configuration item from a section on disk, the first match is returned
      #
      # @param config_file [String] The configuration file to load
      # @param match_field [String, Symbol] The Hash field to match against
      # @param match_value [any] The value to match against
      # @return [Hash] Configuration file contents
      #
      def load_config_file_section_item(config_file, match_field, match_value)
        config = load_config_file_section(config_file)

        return if nil_or_empty?(config)

        item = config.select { |od| od[match_field].eql?(match_value) }
        raise unless item.one?
        item = item.first

        Chef::Log.debug("load_config_file_section_item: #{config_file} match field #{debug_var_output(match_field)} value #{debug_var_output(match_value)}. Result #{debug_var_output(item)}")

        item
      end
    end
  end
end