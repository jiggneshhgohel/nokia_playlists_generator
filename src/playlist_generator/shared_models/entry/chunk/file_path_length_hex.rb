module PlaylistGenerator
  module SharedModels
    module Entry
      module Chunk
        class FilePathLengthHex < ChunkTypeBase

          private

          def _construct_content_arr
            fp = chunk.entry.entry_file_path

            use_as_fp_length = fp.length

            hex_arr = []

            hex_arr << convert_given_integer_to_its_corresponding_hex_value(use_as_fp_length)

            append_null_bytes_to_given_hex_arr_if_its_size_does_not_match_given_size(
              hex_arr: hex_arr, size: chunk.size)

            raise_error_if_chunk_content_arr_size_does_not_match_chunk_size(
              chunk: chunk, chunk_content_arr: hex_arr)

            hex_arr
          end
        end
      end
    end
  end

end
