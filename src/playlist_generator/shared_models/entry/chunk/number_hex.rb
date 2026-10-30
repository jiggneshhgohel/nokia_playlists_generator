module PlaylistGenerator
  module SharedModels
    module Entry
      module Chunk
        class NumberHex < ChunkTypeBase
          attr_reader :number

          def initialize(chunk:, number:)
            super(chunk: chunk)

            @number = number
          end

          private

          def _construct_content_arr
            number_hex_value =
              convert_given_integer_to_its_corresponding_hex_value(number)

            hex_arr = []

            chunk.size.times { hex_arr << number_hex_value }

            raise_error_if_chunk_content_arr_size_does_not_match_chunk_size(
              chunk: chunk, chunk_content_arr: hex_arr)

            hex_arr
          end
        end
      end
    end
  end

end
