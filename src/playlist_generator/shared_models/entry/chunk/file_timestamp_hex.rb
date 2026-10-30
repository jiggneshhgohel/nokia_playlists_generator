module PlaylistGenerator
  module SharedModels
    module Entry
      module Chunk
        class FileTimestampHex < ChunkTypeBase
          # chunk helpers
          include Helpers

          # e.g. 05-10-2026
          DATE_FORMAT = '%d-%m-%Y'
          TIME_FORMAT = '%H:%M:%S'

          attr_reader :entry_source_file_path

          def initialize(chunk:)
            entry_source_fp =
              validate_chunk_entry_has_source_file_path_set!(
                chunk: chunk)

            @chunk = chunk
            @entry_source_file_path = entry_source_fp
          end

          private

          def _construct_content_arr
            fp = entry_source_file_path

            file_time = File.mtime(fp).utc

            file_date = file_time.strftime(DATE_FORMAT)
            file_time_only = file_time.strftime(TIME_FORMAT)

            #puts ">>> file_date: #{file_date}"
            #puts ">>> file_time_only: #{file_time_only}"

            # ----------

            hex_arr_1 = []

            date, month, year = file_date.split(HYPHEN).map(&:to_i)

            #puts ">>>>> file_date_components: date: #{date}, month: #{month}, year: #{year}"

            file_date_components_hex_arr = []
            file_date_components_hex_arr << convert_given_integer_to_its_corresponding_hex_value(date)
            file_date_components_hex_arr << convert_given_integer_to_its_corresponding_hex_value(month)

            year_hex = convert_given_integer_to_its_corresponding_hex_value(year)
            year_hex_arr = convert_given_hex_string_to_arr_of_hex_values(year_hex)
            year_hex_arr.reverse!

            file_date_components_hex_arr += year_hex_arr

            #puts ">>>>> file_date_components_hex_arr: #{file_date_components_hex_arr}"

            hex_arr_1 += file_date_components_hex_arr

            #puts ">>>>> hex_arr_1: #{hex_arr_1}"

            # ----------

            hex_arr_2 = [ NULL_BYTE_HEX_CODE, NULL_BYTE_HEX_CODE ]

            #puts ">>>>> hex_arr_2: #{hex_arr_2}"

            # ----------

            hex_arr_3 = []

            file_time_only_components = file_time_only.split(':').map(&:to_i)

            #puts ">>>>> file_time_only_components: #{file_time_only_components}"

            file_time_only_components_hex_arr =
              file_time_only_components.map do |comp|
                convert_given_integer_to_its_corresponding_hex_value(comp)
              end

            #puts ">>>>> file_time_only_components_hex_arr: #{file_time_only_components_hex_arr}"

            hex_arr_3 += file_time_only_components_hex_arr.reverse

            #puts ">>>>> hex_arr_3: #{hex_arr_3}"

            # ----------

            hex_arr_4 = [ NULL_BYTE_HEX_CODE ]

            #puts ">>>>> hex_arr_4: #{hex_arr_4}"

            # ----------

            hex_arr = hex_arr_1 + hex_arr_2 + hex_arr_3 + hex_arr_4

            raise_error_if_chunk_content_arr_size_does_not_match_chunk_size(
              chunk: chunk, chunk_content_arr: hex_arr)

            hex_arr
          end
        end
      end
    end
  end

end
