# frozen_string_literal: true

require "whats_opt/variable"

module WhatsOpt
  module OpenmdaoVariable
    include WhatsOpt::Variable

    def init_py_value_from(val)
      if self.is_scalar? && val =~ /\[(.*)\]/
        val = $1
      end
      val
    end

    def py_varname
      self.name.tr("./()", "_")
    end

    def py_shortname
      if self.py_varname =~ /^.*:(\w+)$/
        $1
      else
        self.py_varname
      end
    end

    def extended_desc
      desc = ""
      unless self.desc.blank?  
        desc = self.desc 
        desc += " (#{self.units})" unless self.units.blank?
      end
      desc
    end

    def default_py_type
      if self.type == INTEGER_T
        "np.int"
      else
        "np.float"
      end
    end

    def default_py_value
      if self.ndim == 0
        if self.type == FLOAT_T
          "1.0"
        else
          "1"
        end
      else
        if self.type == FLOAT_T
          "np.ones(#{self.shape})"
        else
          "np.ones(#{self.shape}, dtype=np.int)"
        end
      end
    end

    def lower_py_value
      "-inf"
    end

    def upper_py_value
      "inf"
    end

    def cstr_init_py_value
      "0.0"
    end

    def cstr_lower_py_value
      "-inf"
    end

    def cstr_upper_py_value
      "inf"
    end

    def scaling_ref_py_value
      "1.0"
    end

    def scaling_ref0_py_value
      "0.0"
    end

    def scaling_res_ref_py_value
      "1.0"
    end

    def escaped_desc
      s = ""
      unless self.extended_desc.blank?
        s = self.extended_desc.gsub("'", "\\\\'")
      end
      s
    end
  end
end
