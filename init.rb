require 'attr_enum'

ActiveRecord::Base.class_eval { include AttributeModifiers::AttrEnum }
