#
# Autogenerated by Thrift Compiler (0.13.0)
#
# DO NOT EDIT UNLESS YOU ARE SURE THAT YOU KNOW WHAT YOU ARE DOING
#

require 'thrift'
require 'whatsopt_services_types'

module WhatsOpt
  module Services
    module SurrogateStore
      class Client
        include ::Thrift::Client

        def create_surrogate(surrogate_id, kind, xt, yt, options, uncertainties)
          send_create_surrogate(surrogate_id, kind, xt, yt, options, uncertainties)
          recv_create_surrogate()
        end

        def send_create_surrogate(surrogate_id, kind, xt, yt, options, uncertainties)
          send_message('create_surrogate', Create_surrogate_args, :surrogate_id => surrogate_id, :kind => kind, :xt => xt, :yt => yt, :options => options, :uncertainties => uncertainties)
        end

        def recv_create_surrogate()
          result = receive_message(Create_surrogate_result)
          raise result.exc unless result.exc.nil?
          return
        end

        def copy_surrogate(src_id, dst_id)
          send_copy_surrogate(src_id, dst_id)
          recv_copy_surrogate()
        end

        def send_copy_surrogate(src_id, dst_id)
          send_message('copy_surrogate', Copy_surrogate_args, :src_id => src_id, :dst_id => dst_id)
        end

        def recv_copy_surrogate()
          result = receive_message(Copy_surrogate_result)
          raise result.exc unless result.exc.nil?
          return
        end

        def qualify(surrogate_id, xv, yv)
          send_qualify(surrogate_id, xv, yv)
          return recv_qualify()
        end

        def send_qualify(surrogate_id, xv, yv)
          send_message('qualify', Qualify_args, :surrogate_id => surrogate_id, :xv => xv, :yv => yv)
        end

        def recv_qualify()
          result = receive_message(Qualify_result)
          return result.success unless result.success.nil?
          raise result.exc unless result.exc.nil?
          raise ::Thrift::ApplicationException.new(::Thrift::ApplicationException::MISSING_RESULT, 'qualify failed: unknown result')
        end

        def predict_values(surrogate_id, x)
          send_predict_values(surrogate_id, x)
          return recv_predict_values()
        end

        def send_predict_values(surrogate_id, x)
          send_message('predict_values', Predict_values_args, :surrogate_id => surrogate_id, :x => x)
        end

        def recv_predict_values()
          result = receive_message(Predict_values_result)
          return result.success unless result.success.nil?
          raise result.exc unless result.exc.nil?
          raise ::Thrift::ApplicationException.new(::Thrift::ApplicationException::MISSING_RESULT, 'predict_values failed: unknown result')
        end

        def destroy_surrogate(surrogate_id)
          send_destroy_surrogate(surrogate_id)
          recv_destroy_surrogate()
        end

        def send_destroy_surrogate(surrogate_id)
          send_message('destroy_surrogate', Destroy_surrogate_args, :surrogate_id => surrogate_id)
        end

        def recv_destroy_surrogate()
          result = receive_message(Destroy_surrogate_result)
          return
        end

        def get_sobol_pce_sensitivity_analysis(surrogate_id)
          send_get_sobol_pce_sensitivity_analysis(surrogate_id)
          return recv_get_sobol_pce_sensitivity_analysis()
        end

        def send_get_sobol_pce_sensitivity_analysis(surrogate_id)
          send_message('get_sobol_pce_sensitivity_analysis', Get_sobol_pce_sensitivity_analysis_args, :surrogate_id => surrogate_id)
        end

        def recv_get_sobol_pce_sensitivity_analysis()
          result = receive_message(Get_sobol_pce_sensitivity_analysis_result)
          return result.success unless result.success.nil?
          raise ::Thrift::ApplicationException.new(::Thrift::ApplicationException::MISSING_RESULT, 'get_sobol_pce_sensitivity_analysis failed: unknown result')
        end

      end

      class Processor
        include ::Thrift::Processor

        def process_create_surrogate(seqid, iprot, oprot)
          args = read_args(iprot, Create_surrogate_args)
          result = Create_surrogate_result.new()
          begin
            @handler.create_surrogate(args.surrogate_id, args.kind, args.xt, args.yt, args.options, args.uncertainties)
          rescue ::WhatsOpt::Services::SurrogateException => exc
            result.exc = exc
          end
          write_result(result, oprot, 'create_surrogate', seqid)
        end

        def process_copy_surrogate(seqid, iprot, oprot)
          args = read_args(iprot, Copy_surrogate_args)
          result = Copy_surrogate_result.new()
          begin
            @handler.copy_surrogate(args.src_id, args.dst_id)
          rescue ::WhatsOpt::Services::SurrogateException => exc
            result.exc = exc
          end
          write_result(result, oprot, 'copy_surrogate', seqid)
        end

        def process_qualify(seqid, iprot, oprot)
          args = read_args(iprot, Qualify_args)
          result = Qualify_result.new()
          begin
            result.success = @handler.qualify(args.surrogate_id, args.xv, args.yv)
          rescue ::WhatsOpt::Services::SurrogateException => exc
            result.exc = exc
          end
          write_result(result, oprot, 'qualify', seqid)
        end

        def process_predict_values(seqid, iprot, oprot)
          args = read_args(iprot, Predict_values_args)
          result = Predict_values_result.new()
          begin
            result.success = @handler.predict_values(args.surrogate_id, args.x)
          rescue ::WhatsOpt::Services::SurrogateException => exc
            result.exc = exc
          end
          write_result(result, oprot, 'predict_values', seqid)
        end

        def process_destroy_surrogate(seqid, iprot, oprot)
          args = read_args(iprot, Destroy_surrogate_args)
          result = Destroy_surrogate_result.new()
          @handler.destroy_surrogate(args.surrogate_id)
          write_result(result, oprot, 'destroy_surrogate', seqid)
        end

        def process_get_sobol_pce_sensitivity_analysis(seqid, iprot, oprot)
          args = read_args(iprot, Get_sobol_pce_sensitivity_analysis_args)
          result = Get_sobol_pce_sensitivity_analysis_result.new()
          result.success = @handler.get_sobol_pce_sensitivity_analysis(args.surrogate_id)
          write_result(result, oprot, 'get_sobol_pce_sensitivity_analysis', seqid)
        end

      end

      # HELPER FUNCTIONS AND STRUCTURES

      class Create_surrogate_args
        include ::Thrift::Struct, ::Thrift::Struct_Union
        SURROGATE_ID = 1
        KIND = 2
        XT = 3
        YT = 4
        OPTIONS = 5
        UNCERTAINTIES = 6

        FIELDS = {
          SURROGATE_ID => {:type => ::Thrift::Types::STRING, :name => 'surrogate_id'},
          KIND => {:type => ::Thrift::Types::I32, :name => 'kind', :enum_class => ::WhatsOpt::Services::SurrogateKind},
          XT => {:type => ::Thrift::Types::LIST, :name => 'xt', :element => {:type => ::Thrift::Types::LIST, :element => {:type => ::Thrift::Types::DOUBLE}}},
          YT => {:type => ::Thrift::Types::LIST, :name => 'yt', :element => {:type => ::Thrift::Types::DOUBLE}},
          OPTIONS => {:type => ::Thrift::Types::MAP, :name => 'options', :key => {:type => ::Thrift::Types::STRING}, :value => {:type => ::Thrift::Types::STRUCT, :class => ::WhatsOpt::Services::OptionValue}},
          UNCERTAINTIES => {:type => ::Thrift::Types::LIST, :name => 'uncertainties', :element => {:type => ::Thrift::Types::STRUCT, :class => ::WhatsOpt::Services::Distribution}}
        }

        def struct_fields; FIELDS; end

        def validate
          unless @kind.nil? || ::WhatsOpt::Services::SurrogateKind::VALID_VALUES.include?(@kind)
            raise ::Thrift::ProtocolException.new(::Thrift::ProtocolException::UNKNOWN, 'Invalid value of field kind!')
          end
        end

        ::Thrift::Struct.generate_accessors self
      end

      class Create_surrogate_result
        include ::Thrift::Struct, ::Thrift::Struct_Union
        EXC = 1

        FIELDS = {
          EXC => {:type => ::Thrift::Types::STRUCT, :name => 'exc', :class => ::WhatsOpt::Services::SurrogateException}
        }

        def struct_fields; FIELDS; end

        def validate
        end

        ::Thrift::Struct.generate_accessors self
      end

      class Copy_surrogate_args
        include ::Thrift::Struct, ::Thrift::Struct_Union
        SRC_ID = 1
        DST_ID = 2

        FIELDS = {
          SRC_ID => {:type => ::Thrift::Types::STRING, :name => 'src_id'},
          DST_ID => {:type => ::Thrift::Types::STRING, :name => 'dst_id'}
        }

        def struct_fields; FIELDS; end

        def validate
        end

        ::Thrift::Struct.generate_accessors self
      end

      class Copy_surrogate_result
        include ::Thrift::Struct, ::Thrift::Struct_Union
        EXC = 1

        FIELDS = {
          EXC => {:type => ::Thrift::Types::STRUCT, :name => 'exc', :class => ::WhatsOpt::Services::SurrogateException}
        }

        def struct_fields; FIELDS; end

        def validate
        end

        ::Thrift::Struct.generate_accessors self
      end

      class Qualify_args
        include ::Thrift::Struct, ::Thrift::Struct_Union
        SURROGATE_ID = 1
        XV = 2
        YV = 3

        FIELDS = {
          SURROGATE_ID => {:type => ::Thrift::Types::STRING, :name => 'surrogate_id'},
          XV => {:type => ::Thrift::Types::LIST, :name => 'xv', :element => {:type => ::Thrift::Types::LIST, :element => {:type => ::Thrift::Types::DOUBLE}}},
          YV => {:type => ::Thrift::Types::LIST, :name => 'yv', :element => {:type => ::Thrift::Types::DOUBLE}}
        }

        def struct_fields; FIELDS; end

        def validate
        end

        ::Thrift::Struct.generate_accessors self
      end

      class Qualify_result
        include ::Thrift::Struct, ::Thrift::Struct_Union
        SUCCESS = 0
        EXC = 1

        FIELDS = {
          SUCCESS => {:type => ::Thrift::Types::STRUCT, :name => 'success', :class => ::WhatsOpt::Services::SurrogateQualification},
          EXC => {:type => ::Thrift::Types::STRUCT, :name => 'exc', :class => ::WhatsOpt::Services::SurrogateException}
        }

        def struct_fields; FIELDS; end

        def validate
        end

        ::Thrift::Struct.generate_accessors self
      end

      class Predict_values_args
        include ::Thrift::Struct, ::Thrift::Struct_Union
        SURROGATE_ID = 1
        X = 2

        FIELDS = {
          SURROGATE_ID => {:type => ::Thrift::Types::STRING, :name => 'surrogate_id'},
          X => {:type => ::Thrift::Types::LIST, :name => 'x', :element => {:type => ::Thrift::Types::LIST, :element => {:type => ::Thrift::Types::DOUBLE}}}
        }

        def struct_fields; FIELDS; end

        def validate
        end

        ::Thrift::Struct.generate_accessors self
      end

      class Predict_values_result
        include ::Thrift::Struct, ::Thrift::Struct_Union
        SUCCESS = 0
        EXC = 1

        FIELDS = {
          SUCCESS => {:type => ::Thrift::Types::LIST, :name => 'success', :element => {:type => ::Thrift::Types::DOUBLE}},
          EXC => {:type => ::Thrift::Types::STRUCT, :name => 'exc', :class => ::WhatsOpt::Services::SurrogateException}
        }

        def struct_fields; FIELDS; end

        def validate
        end

        ::Thrift::Struct.generate_accessors self
      end

      class Destroy_surrogate_args
        include ::Thrift::Struct, ::Thrift::Struct_Union
        SURROGATE_ID = 1

        FIELDS = {
          SURROGATE_ID => {:type => ::Thrift::Types::STRING, :name => 'surrogate_id'}
        }

        def struct_fields; FIELDS; end

        def validate
        end

        ::Thrift::Struct.generate_accessors self
      end

      class Destroy_surrogate_result
        include ::Thrift::Struct, ::Thrift::Struct_Union

        FIELDS = {

        }

        def struct_fields; FIELDS; end

        def validate
        end

        ::Thrift::Struct.generate_accessors self
      end

      class Get_sobol_pce_sensitivity_analysis_args
        include ::Thrift::Struct, ::Thrift::Struct_Union
        SURROGATE_ID = 1

        FIELDS = {
          SURROGATE_ID => {:type => ::Thrift::Types::STRING, :name => 'surrogate_id'}
        }

        def struct_fields; FIELDS; end

        def validate
        end

        ::Thrift::Struct.generate_accessors self
      end

      class Get_sobol_pce_sensitivity_analysis_result
        include ::Thrift::Struct, ::Thrift::Struct_Union
        SUCCESS = 0

        FIELDS = {
          SUCCESS => {:type => ::Thrift::Types::STRUCT, :name => 'success', :class => ::WhatsOpt::Services::SobolIndices}
        }

        def struct_fields; FIELDS; end

        def validate
        end

        ::Thrift::Struct.generate_accessors self
      end

    end

  end
end
