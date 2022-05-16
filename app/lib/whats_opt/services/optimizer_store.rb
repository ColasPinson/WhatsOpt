#
# Autogenerated by Thrift Compiler (0.13.0)
#
# DO NOT EDIT UNLESS YOU ARE SURE THAT YOU KNOW WHAT YOU ARE DOING
#

require 'thrift'
require 'whatsopt_services_types'

module WhatsOpt
  module Services
    module OptimizerStore
      class Client
        include ::Thrift::Client

        def create_optimizer(optimizer_id, kind, xlimits, cstr_specs, options)
          send_create_optimizer(optimizer_id, kind, xlimits, cstr_specs, options)
          recv_create_optimizer()
        end

        def send_create_optimizer(optimizer_id, kind, xlimits, cstr_specs, options)
          send_message('create_optimizer', Create_optimizer_args, :optimizer_id => optimizer_id, :kind => kind, :xlimits => xlimits, :cstr_specs => cstr_specs, :options => options)
        end

        def recv_create_optimizer()
          result = receive_message(Create_optimizer_result)
          raise result.exc unless result.exc.nil?
          return
        end

        def create_mixint_optimizer(optimizer_id, kind, xtypes, cstr_specs, options)
          send_create_mixint_optimizer(optimizer_id, kind, xtypes, cstr_specs, options)
          recv_create_mixint_optimizer()
        end

        def send_create_mixint_optimizer(optimizer_id, kind, xtypes, cstr_specs, options)
          send_message('create_mixint_optimizer', Create_mixint_optimizer_args, :optimizer_id => optimizer_id, :kind => kind, :xtypes => xtypes, :cstr_specs => cstr_specs, :options => options)
        end

        def recv_create_mixint_optimizer()
          result = receive_message(Create_mixint_optimizer_result)
          raise result.exc unless result.exc.nil?
          return
        end

        def ask(optimizer_id)
          send_ask(optimizer_id)
          return recv_ask()
        end

        def send_ask(optimizer_id)
          send_message('ask', Ask_args, :optimizer_id => optimizer_id)
        end

        def recv_ask()
          result = receive_message(Ask_result)
          return result.success unless result.success.nil?
          raise result.exc unless result.exc.nil?
          raise ::Thrift::ApplicationException.new(::Thrift::ApplicationException::MISSING_RESULT, 'ask failed: unknown result')
        end

        def tell(optimizer_id, x, y)
          send_tell(optimizer_id, x, y)
          recv_tell()
        end

        def send_tell(optimizer_id, x, y)
          send_message('tell', Tell_args, :optimizer_id => optimizer_id, :x => x, :y => y)
        end

        def recv_tell()
          result = receive_message(Tell_result)
          raise result.exc unless result.exc.nil?
          return
        end

        def destroy_optimizer(surrogate_id)
          send_destroy_optimizer(surrogate_id)
          recv_destroy_optimizer()
        end

        def send_destroy_optimizer(surrogate_id)
          send_message('destroy_optimizer', Destroy_optimizer_args, :surrogate_id => surrogate_id)
        end

        def recv_destroy_optimizer()
          result = receive_message(Destroy_optimizer_result)
          return
        end

      end

      class Processor
        include ::Thrift::Processor

        def process_create_optimizer(seqid, iprot, oprot)
          args = read_args(iprot, Create_optimizer_args)
          result = Create_optimizer_result.new()
          begin
            @handler.create_optimizer(args.optimizer_id, args.kind, args.xlimits, args.cstr_specs, args.options)
          rescue ::WhatsOpt::Services::OptimizerException => exc
            result.exc = exc
          end
          write_result(result, oprot, 'create_optimizer', seqid)
        end

        def process_create_mixint_optimizer(seqid, iprot, oprot)
          args = read_args(iprot, Create_mixint_optimizer_args)
          result = Create_mixint_optimizer_result.new()
          begin
            @handler.create_mixint_optimizer(args.optimizer_id, args.kind, args.xtypes, args.cstr_specs, args.options)
          rescue ::WhatsOpt::Services::OptimizerException => exc
            result.exc = exc
          end
          write_result(result, oprot, 'create_mixint_optimizer', seqid)
        end

        def process_ask(seqid, iprot, oprot)
          args = read_args(iprot, Ask_args)
          result = Ask_result.new()
          begin
            result.success = @handler.ask(args.optimizer_id)
          rescue ::WhatsOpt::Services::OptimizerException => exc
            result.exc = exc
          end
          write_result(result, oprot, 'ask', seqid)
        end

        def process_tell(seqid, iprot, oprot)
          args = read_args(iprot, Tell_args)
          result = Tell_result.new()
          begin
            @handler.tell(args.optimizer_id, args.x, args.y)
          rescue ::WhatsOpt::Services::OptimizerException => exc
            result.exc = exc
          end
          write_result(result, oprot, 'tell', seqid)
        end

        def process_destroy_optimizer(seqid, iprot, oprot)
          args = read_args(iprot, Destroy_optimizer_args)
          result = Destroy_optimizer_result.new()
          @handler.destroy_optimizer(args.surrogate_id)
          write_result(result, oprot, 'destroy_optimizer', seqid)
        end

      end

      # HELPER FUNCTIONS AND STRUCTURES

      class Create_optimizer_args
        include ::Thrift::Struct, ::Thrift::Struct_Union
        OPTIMIZER_ID = 1
        KIND = 2
        XLIMITS = 3
        CSTR_SPECS = 4
        OPTIONS = 5

        FIELDS = {
          OPTIMIZER_ID => {:type => ::Thrift::Types::STRING, :name => 'optimizer_id'},
          KIND => {:type => ::Thrift::Types::I32, :name => 'kind', :enum_class => ::WhatsOpt::Services::OptimizerKind},
          XLIMITS => {:type => ::Thrift::Types::LIST, :name => 'xlimits', :element => {:type => ::Thrift::Types::LIST, :element => {:type => ::Thrift::Types::DOUBLE}}},
          CSTR_SPECS => {:type => ::Thrift::Types::LIST, :name => 'cstr_specs', :element => {:type => ::Thrift::Types::STRUCT, :class => ::WhatsOpt::Services::ConstraintSpec}},
          OPTIONS => {:type => ::Thrift::Types::MAP, :name => 'options', :key => {:type => ::Thrift::Types::STRING}, :value => {:type => ::Thrift::Types::STRUCT, :class => ::WhatsOpt::Services::OptionValue}}
        }

        def struct_fields; FIELDS; end

        def validate
          unless @kind.nil? || ::WhatsOpt::Services::OptimizerKind::VALID_VALUES.include?(@kind)
            raise ::Thrift::ProtocolException.new(::Thrift::ProtocolException::UNKNOWN, 'Invalid value of field kind!')
          end
        end

        ::Thrift::Struct.generate_accessors self
      end

      class Create_optimizer_result
        include ::Thrift::Struct, ::Thrift::Struct_Union
        EXC = 1

        FIELDS = {
          EXC => {:type => ::Thrift::Types::STRUCT, :name => 'exc', :class => ::WhatsOpt::Services::OptimizerException}
        }

        def struct_fields; FIELDS; end

        def validate
        end

        ::Thrift::Struct.generate_accessors self
      end

      class Create_mixint_optimizer_args
        include ::Thrift::Struct, ::Thrift::Struct_Union
        OPTIMIZER_ID = 1
        KIND = 2
        XTYPES = 3
        CSTR_SPECS = 4
        OPTIONS = 5

        FIELDS = {
          OPTIMIZER_ID => {:type => ::Thrift::Types::STRING, :name => 'optimizer_id'},
          KIND => {:type => ::Thrift::Types::I32, :name => 'kind', :enum_class => ::WhatsOpt::Services::OptimizerKind},
          XTYPES => {:type => ::Thrift::Types::LIST, :name => 'xtypes', :element => {:type => ::Thrift::Types::STRUCT, :class => ::WhatsOpt::Services::Xtype}},
          CSTR_SPECS => {:type => ::Thrift::Types::LIST, :name => 'cstr_specs', :element => {:type => ::Thrift::Types::STRUCT, :class => ::WhatsOpt::Services::ConstraintSpec}},
          OPTIONS => {:type => ::Thrift::Types::MAP, :name => 'options', :key => {:type => ::Thrift::Types::STRING}, :value => {:type => ::Thrift::Types::STRUCT, :class => ::WhatsOpt::Services::OptionValue}}
        }

        def struct_fields; FIELDS; end

        def validate
          unless @kind.nil? || ::WhatsOpt::Services::OptimizerKind::VALID_VALUES.include?(@kind)
            raise ::Thrift::ProtocolException.new(::Thrift::ProtocolException::UNKNOWN, 'Invalid value of field kind!')
          end
        end

        ::Thrift::Struct.generate_accessors self
      end

      class Create_mixint_optimizer_result
        include ::Thrift::Struct, ::Thrift::Struct_Union
        EXC = 1

        FIELDS = {
          EXC => {:type => ::Thrift::Types::STRUCT, :name => 'exc', :class => ::WhatsOpt::Services::OptimizerException}
        }

        def struct_fields; FIELDS; end

        def validate
        end

        ::Thrift::Struct.generate_accessors self
      end

      class Ask_args
        include ::Thrift::Struct, ::Thrift::Struct_Union
        OPTIMIZER_ID = 1

        FIELDS = {
          OPTIMIZER_ID => {:type => ::Thrift::Types::STRING, :name => 'optimizer_id'}
        }

        def struct_fields; FIELDS; end

        def validate
        end

        ::Thrift::Struct.generate_accessors self
      end

      class Ask_result
        include ::Thrift::Struct, ::Thrift::Struct_Union
        SUCCESS = 0
        EXC = 1

        FIELDS = {
          SUCCESS => {:type => ::Thrift::Types::STRUCT, :name => 'success', :class => ::WhatsOpt::Services::OptimizerResult},
          EXC => {:type => ::Thrift::Types::STRUCT, :name => 'exc', :class => ::WhatsOpt::Services::OptimizerException}
        }

        def struct_fields; FIELDS; end

        def validate
        end

        ::Thrift::Struct.generate_accessors self
      end

      class Tell_args
        include ::Thrift::Struct, ::Thrift::Struct_Union
        OPTIMIZER_ID = 1
        X = 2
        Y = 3

        FIELDS = {
          OPTIMIZER_ID => {:type => ::Thrift::Types::STRING, :name => 'optimizer_id'},
          X => {:type => ::Thrift::Types::LIST, :name => 'x', :element => {:type => ::Thrift::Types::LIST, :element => {:type => ::Thrift::Types::DOUBLE}}},
          Y => {:type => ::Thrift::Types::LIST, :name => 'y', :element => {:type => ::Thrift::Types::LIST, :element => {:type => ::Thrift::Types::DOUBLE}}}
        }

        def struct_fields; FIELDS; end

        def validate
        end

        ::Thrift::Struct.generate_accessors self
      end

      class Tell_result
        include ::Thrift::Struct, ::Thrift::Struct_Union
        EXC = 1

        FIELDS = {
          EXC => {:type => ::Thrift::Types::STRUCT, :name => 'exc', :class => ::WhatsOpt::Services::OptimizerException}
        }

        def struct_fields; FIELDS; end

        def validate
        end

        ::Thrift::Struct.generate_accessors self
      end

      class Destroy_optimizer_args
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

      class Destroy_optimizer_result
        include ::Thrift::Struct, ::Thrift::Struct_Union

        FIELDS = {

        }

        def struct_fields; FIELDS; end

        def validate
        end

        ::Thrift::Struct.generate_accessors self
      end

    end

  end
end
