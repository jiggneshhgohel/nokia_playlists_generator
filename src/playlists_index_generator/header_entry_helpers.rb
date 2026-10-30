module PlaylistsIndexGenerator
  module HeaderEntryHelpers
    include ::PlaylistsIndexGenerator::SharedHelpers

    private

    def header_entry_schema_json_hash
      @header_entry_schema_json_hash ||=
        playlists_index_schema_json_hash[:header_entry]
    end

    def header_entry_schema_values_json_hash
      @header_entry_schema_values_json_hash ||=
        playlists_index_schema_values_json_hash[SCHEMA_VALUES_JSON_HEADER_ENTRY_KEY]
    end

    def create_header_entry
      header_entry_size = header_entry_schema_json_hash[:size]
      header_entry_file_path = HEADER_ENTRY_FILE_PATH
      header_entry_chunks_data_definition_data = header_entry_schema_json_hash[:chunks]
      header_entry_chunks_data = _create_plif_header_entry_chunks_data

      header_entry_obj =
        create_plif_entry(
          entry_size: header_entry_size,
          entry_file_path: header_entry_file_path,
          entry_chunks_data_definition_data: header_entry_chunks_data_definition_data,
          entry_chunks_data: header_entry_chunks_data)

      header_entry_obj
    end

    def _create_plif_header_entry_chunks_data
      original_chunks_data_hash =
        fetch_chunks_data_from_given_entry_schema_values_json_hash(
          entry_schema_values_json_hash: header_entry_schema_values_json_hash)

      h =
        transform_given_chunks_data_hash_keys_to_integer(
          chunks_data_hash: original_chunks_data_hash)

      h
    end
  end
end
