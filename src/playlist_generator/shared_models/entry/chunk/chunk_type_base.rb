module PlaylistGenerator
  module SharedModels
    module Entry
      module Chunk
        class ChunkTypeBase
          include ::PlaylistGenerator::SharedHelpers

          attr_reader :chunk

          def initialize(chunk:)
            @chunk = chunk
          end

          def content(format: true)
            result =
              join_given_hex_strings_arr(
                hex_arr: content_arr, format: format)

            result
          end

          def content_arr
            @content_arr ||= begin
              arr = _construct_content_arr
              arr.freeze
              arr
            end
          end

          private

          def _construct_content_arr
            raise_error(error_msg: "private method :_construct_content_arr must be implemented by this class's subclasses")
          end
        end
      end
    end
  end

end
