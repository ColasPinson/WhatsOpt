#
# Autogenerated by Thrift Compiler (0.13.0)
#
# DO NOT EDIT UNLESS YOU ARE SURE THAT YOU KNOW WHAT YOU ARE DOING
#

require 'thrift'
require 'whatsopt_services_types'

module WhatsOpt
  module Services
    module Administration
      class Client
        include ::Thrift::Client

        def ping()
          send_ping()
          recv_ping()
        end

        def send_ping()
          send_message('ping', Ping_args)
        end

        def recv_ping()
          result = receive_message(Ping_result)
          return
        end

        def shutdown()
          send_shutdown()
        end

        def send_shutdown()
          send_oneway_message('shutdown', Shutdown_args)
        end
      end

      class Processor
        include ::Thrift::Processor

        def process_ping(seqid, iprot, oprot)
          args = read_args(iprot, Ping_args)
          result = Ping_result.new()
          @handler.ping()
          write_result(result, oprot, 'ping', seqid)
        end

        def process_shutdown(seqid, iprot, oprot)
          args = read_args(iprot, Shutdown_args)
          @handler.shutdown()
          return
        end

      end

      # HELPER FUNCTIONS AND STRUCTURES

      class Ping_args
        include ::Thrift::Struct, ::Thrift::Struct_Union

        FIELDS = {

        }

        def struct_fields; FIELDS; end

        def validate
        end

        ::Thrift::Struct.generate_accessors self
      end

      class Ping_result
        include ::Thrift::Struct, ::Thrift::Struct_Union

        FIELDS = {

        }

        def struct_fields; FIELDS; end

        def validate
        end

        ::Thrift::Struct.generate_accessors self
      end

      class Shutdown_args
        include ::Thrift::Struct, ::Thrift::Struct_Union

        FIELDS = {

        }

        def struct_fields; FIELDS; end

        def validate
        end

        ::Thrift::Struct.generate_accessors self
      end

      class Shutdown_result
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
