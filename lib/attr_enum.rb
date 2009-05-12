module AttributeModifiers
  module AttrEnum
    def self.included(base)
      base.extend ClassMethods
    end
  
    module ClassMethods
      def attr_enum(attr_name, enum_map)
        ids = []
        constant_defs = []
        id_to_name_map = {}
        enum_map.each do |sym, opts|
          case opts
            when Hash
              id = opts[:id]
              name = opts[:name]
            else
              id = opts
          end
        
          name ||= sym.to_s.humanize
        
          ids << id
          constant_name = sym.to_s.camelize
          id_to_name_map[id] = name
          constant_defs << "#{constant_name} = #{id}"
        
          define_method "#{attr_name}_#{sym}?" do
            self.send(attr_name) == id
          end
        end

        options = ids.map { |id| 
          [id_to_name_map[id], id.to_s]
        }
      
        module_name = attr_name.to_s.camelize
        class_eval <<-eos
          module #{module_name}
            #{constant_defs.join("\n")}

            def #{module_name}.values
              [#{ids.sort.join(",")}]
            end
            
            def #{module_name}.options
              #{options.inspect}
            end
          end
        eos
      
        define_method "#{attr_name}_name" do
          id_to_name_map[self.send(attr_name)]
        end
      end
    end
  end
end