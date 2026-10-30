module PlaylistGenerator
  module SharedModels
    module Entry
      module Chunk
        class FilePathCharsHex < ChunkTypeBase
          include ::PlaylistGenerator::SharedHelpers

          private

          def _construct_content_arr
            fp = chunk.entry.entry_file_path

            hex_str = convert_given_string_to_its_hex_representation(fp)

            hex_arr = convert_given_hex_string_to_arr_of_hex_values(hex_str)

            hex_arr_2 = []

            hex_arr.each do |hex|
              hex_arr_2 << hex
              hex_arr_2 << NULL_BYTE_HEX_CODE
            end

            append_null_bytes_to_given_hex_arr_if_its_size_does_not_match_given_size(
              hex_arr: hex_arr_2, size: chunk.size)

            raise_error_if_chunk_content_arr_size_does_not_match_chunk_size(
              chunk: chunk, chunk_content_arr: hex_arr_2)

            hex_arr_2
          end
        end
      end
    end
  end

end

