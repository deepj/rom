module ROM
  module Plugins
    module Schema
      # A plugin for automatically adding timestamp fields
      # to the schema definition
      #
      # @example
      #   schema do
      #     use :timestamps
      #   end
      #
      #   # using non-default names
      #   schema do
      #     use :timestamps, attributes: %i(created_on updated_on)
      #   end
      #
      #   # using other types
      #   schema do
      #     use :timestamps, type: Types::Date
      #   end
      #
      # @api public
      module Timestamps
        DEFAULT_TIMESTAMPS = %i(created_at updated_at).freeze

        # @api private
        def self.apply(schema, options)
          type = options.fetch(:type, Types::Time)
          names = options.fetch(:attributes, DEFAULT_TIMESTAMPS)
          attributes = names.map { |name| type.meta(name: name, source: schema.name) }

          schema.attributes.concat(
            schema.class.attributes(attributes, schema.attr_class)
          )
        end

        # @api private
        module DSL
          # Sets non-default timestamp attributes
          #
          # @example
          #   schema do
          #     use :timestamps
          #     timestamps :create_on, :updated_on
          #   end
          #
          # @api public
          def timestamps(*names)
            options = plugin_options(:timestamps)
            options[:attributes] = names unless names.empty?

            self
          end
        end
      end
    end
  end
end
