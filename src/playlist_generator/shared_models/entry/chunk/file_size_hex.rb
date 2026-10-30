module PlaylistGenerator
  module SharedModels
    module Entry
      module Chunk
        class FileSizeHex < ChunkTypeBase
          # chunk helpers
          include Helpers

          attr_reader :entry_source_file_path

          def initialize(chunk:)
            entry_source_fp =
              validate_chunk_entry_has_source_file_path_set!(
                chunk: chunk)

            super
            @entry_source_file_path = entry_source_fp
          end

          private

          def _construct_content_arr
            fp = entry_source_file_path

            file_size_in_bytes = File.size(fp)

            #puts ">>>>> file_size_in_bytes: #{file_size_in_bytes}"

            file_size_in_hex =
              convert_given_integer_to_its_corresponding_hex_value(
                file_size_in_bytes)

            #puts ">>>>> file_size_in_hex: #{file_size_in_hex}"

            hex_arr =
              convert_given_hex_string_to_arr_of_hex_values(file_size_in_hex)

            #puts ">>>>> hex_arr: #{hex_arr}"

            hex_arr.reverse!

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
