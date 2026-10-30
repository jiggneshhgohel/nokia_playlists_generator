module PlaylistGenerator
  module SharedModels
    module Entry
      module Chunk
        class StringHex < ChunkTypeBase
          attr_reader :string

          def initialize(chunk:, string:)
            super(chunk: chunk)

            @string = string
          end

          private

          def _construct_content_arr
            string_hex_representation =
              convert_given_string_to_its_hex_representation(string)

            hex_arr =
              convert_given_hex_string_to_arr_of_hex_values(
                string_hex_representation)

            raise_error_if_chunk_content_arr_size_does_not_match_chunk_size(
              chunk: chunk, chunk_content_arr: hex_arr)

            hex_arr
          end
        end
      end
    end
  end

end
