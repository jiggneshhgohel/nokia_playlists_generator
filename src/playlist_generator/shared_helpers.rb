require 'fileutils'

module PlaylistGenerator
  module SharedHelpers
    SINGLE_SPACE = ' '
    HYPHEN = '-'

    BACKWARD_SLASH = '/'
    FORWARD_SLASH = '\\'

    NULL_BYTE_HEX_CODE = '00'

    EMPTY_ARRAY = [].freeze

    # Note: The values for the `SCHEMA_VALUES_JSON` prefixed constants
    # below are based on contents in
    # `*.schema.` and `*.schema_values.json` files defined under folder
    # `phone_model/nokia_220_4g_2024`.
    SCHEMA_VALUES_JSON_HEADER_ENTRY_KEY = 'header_entry'
    SCHEMA_VALUES_JSON_CHUNKS_DATA_KEY = 'chunks_data'

    HEADER_ENTRY_FILE_PATH = 'NA for Header Entry'

    def set_instance_variables_for_given_required_args!(required_args_name_arr:, received_args:)
      required_args_name_arr.each do |arg_name|
        arg_val = received_args.fetch(arg_name) { raise ArgumentError, "Missing required argument: :#{arg_name}" }

        instance_var_name = "@#{arg_name}".to_sym

        instance_variable_set(instance_var_name, arg_val)
      end
    end

    def fetch_chunks_data_from_given_entry_schema_values_json_hash(entry_schema_values_json_hash:)
      entry_schema_values_json_hash[SCHEMA_VALUES_JSON_CHUNKS_DATA_KEY]
    end

    def transform_given_chunks_data_hash_keys_to_integer(chunks_data_hash:)
      chunks_data_hash.transform_keys(&:to_i)
    end

    def convert_given_integer_to_its_corresponding_hex_value(integer_value, should_upcase_hex: true)
      # `number.to_s(16)` converts the number (for e.g. 65) directly to its base-16 string.
      result = integer_value.to_s(16).upcase

      result.upcase! if !!should_upcase_hex

      if result.length.odd?
        result = "0#{result}"
      end

      result
    end

    def convert_given_string_to_its_hex_representation(str, should_upcase_hex: true)
      # `unpack1` extracts the byte of `str` and reads high-nibble first.
      # For e.g. for str received as "A" whose binary value is 0100 0001
      # and hex value is 41 wherein 4 represents the high nibble (4-bits)
      # in the binary value and 1 represents the low nibble, 'H*'
      # reads high-nibble first thus "A".unpack1('H*') would return "41".

      result = str.unpack1('H*')

      result.upcase! if !!should_upcase_hex

      result
    end

    def convert_given_hex_string_to_arr_of_hex_values(hex_str)
      # The regex /../ matches any two consecutive characters (since a dot . represents any single character).
      # Because each hex byte is exactly two characters long (e.g., '4d' is M, '55' is U),
      # scan for pairs to get an array of individual hex bytes
      hex_str.scan(/../)
    end

    def join_strings_in_given_arr(arr:, separator: nil)
      if !!separator
        result = arr.join(separator)

      else
        result = arr.join
      end

      result
    end

    def join_given_strings_arr(str_arr:, format: true)
      use_as_separator = !!format ? SINGLE_SPACE : nil

      join_strings_in_given_arr(arr: str_arr, separator: use_as_separator)
    end

    def join_given_hex_strings_arr(hex_arr:, format: true)
      join_given_strings_arr(str_arr: hex_arr, format: format)
    end

    def squish_str(str)
      str.strip.gsub(/[[:space:]]+/, ' ')
    end

    def replace_backward_slashes_in_given_str_with_forward_slash(str)
      str.gsub(BACKWARD_SLASH, FORWARD_SLASH)
    end

    def raise_error(error_msg:)
      raise error_msg
    end

    def raise_error_if_chunk_content_arr_size_does_not_match_chunk_size(chunk:, chunk_content_arr:)
      chunk_size = chunk.size
      chunk_content_arr_size = chunk_content_arr.size

      return if chunk_content_arr_size == chunk_size

      error_msg = squish_str(%Q{
        Chunk type '#{chunk.type}' content size must be #{chunk_size}.
        It is found to be #{chunk_content_arr_size}.
      })

      raise_error(error_msg: error_msg)
    end

    def append_null_bytes_to_given_hex_arr_if_its_size_does_not_match_given_size(hex_arr:, size:)
      hex_arr_current_size = hex_arr.size

      if hex_arr_current_size < size
        (size - hex_arr_current_size).times do
          hex_arr << NULL_BYTE_HEX_CODE
        end
      end

      hex_arr
    end

    def create_binary_content_file(file_path:, file_data_arr:)
      FileUtils.mkdir_p(File.dirname(file_path))

      File.open(file_path, 'wb') do |file|
        file_data_arr.each do |fdata|
          binary_data = [fdata].pack('H*')
          file.write(binary_data)
        end
      end
    end

  end
end
