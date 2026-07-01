module SpreeVolumePricing
  class Engine < Rails::Engine
    require 'spree/core'
    isolate_namespace Spree
    engine_name 'spree_volume_pricing'

    initializer 'spree_volume_pricing.preferences', before: 'spree.environment' do
      # Spree 4.5 renamed Spree::AppConfiguration to Spree::Core::Configuration.
      # Prefer the old name when present so this branch keeps working across the
      # whole 4.x line (4.3/4.4 still expose AppConfiguration; 4.5+ only Core::Configuration).
      preferences_class = defined?(Spree::AppConfiguration) ? Spree::AppConfiguration : Spree::Core::Configuration
      preferences_class.class_eval do
        preference :use_master_variant_volume_pricing, :boolean, default: false
        preference :volume_pricing_role, :string, default: 'wholesale'
        preference :volume_pricing_role_dropship, :string, default: 'dropship'
      end
    end

    def self.activate
      Dir.glob(File.join(File.dirname(__FILE__), '../../app/**/*_decorator*.rb')) do |c|
        Rails.configuration.cache_classes ? require(c) : load(c)
      end

      String.class_eval do
        def to_range
          case count('.')
          when 2
            elements = split('..')
            return Range.new(elements[0].delete('(').to_i, elements[1].to_i)
          when 3
            elements = split('...')
            return Range.new(elements[0].delete('(').to_i, elements[1].to_i - 1)
          else
            raise ArgumentError.new(
              I18n.t(
                :'activerecord.errors.messages.could_not_conver_to_range',
                number: self
              )
            )
          end
        end
      end
    end

    config.autoload_paths += %W(#{config.root}/lib)
    config.to_prepare(&method(:activate).to_proc)
  end
end
