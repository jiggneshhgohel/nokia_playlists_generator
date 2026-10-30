module PlaylistsIndexGenerator
  module DefaultPlaylistsEntriesHelpers
    include ::PlaylistsIndexGenerator::PlaylistsEntriesHelpers

    private

    # pls -> playlists

    def default_pls_count
      @default_pls_count ||= default_playlists_path_arr.size
    end

    def default_pls_schema_values_json_hash
      @default_pls_schema_values_json_hash ||=
        playlists_index_schema_values_json_hash[PLI_SCHEMA_VALUES_JSON_DEFAULT_PLAYLISTS_KEY]
    end

    def default_pls_count_specific_schema_values_json_hash
      @default_pls_count_specific_schema_values_json_hash ||= begin
        # svj -> schema_values_json

        if PLI_SCHEMA_VALUES_JSON_DEFAULT_PLS_COUNT_MENTIONED_ARR.include?(default_pls_count)
          default_pls_svj_hash_key = default_pls_count.to_s
        end

        default_pls_count_specific_svj_hash =
          default_pls_schema_values_json_hash[default_pls_svj_hash_key]

        default_pls_count_specific_svj_hash
      end
    end

    def default_pls_pl_entry_schema_values_json_hash
      @default_pls_pl_entry_schema_values_json_hash ||= begin
        hash = default_pls_count_specific_schema_values_json_hash

        _get_pl_entry_schema_values_json_hash_from_given_hash(hash)
      end
    end

    def default_pls_last_pl_entry_schema_values_json_hash
      @default_pls_last_pl_entry_schema_values_json_hash ||= begin
        hash = default_pls_count_specific_schema_values_json_hash

        _get_last_pl_entry_schema_values_json_hash_from_given_hash(hash)
      end
    end

    def create_plif_entries_for_default_playlists
      all_entries_chunks_data_for_default_playlists =
        _create_plif_entries_chunks_data_for_default_playlists

      pl_entry_size = pl_entry_schema_json_hash[:size]
      pl_entry_chunks_data_definition_data = pl_entry_schema_json_hash[:chunks]

      default_pls_entry_obj_arr =
        _create_entry_obj_arr_for_given_pls_path_arr(
          pls_path_arr: default_playlists_path_arr,
          plif_all_entries_chunks_data_for_pls: all_entries_chunks_data_for_default_playlists,
          use_as_plif_entry_chunks_data_definition_data_for_last_pl_path: pl_entry_chunks_data_definition_data,
          use_as_plif_entry_size_for_last_pl_path: pl_entry_size)

      default_pls_entry_obj_arr
    end

    def _create_plif_entries_chunks_data_for_default_playlists
      # dp -> default_playlist
      dp_num_to_entry_chunks_data_hash =
        _extract_chunks_data_for_pl_entries_from_given_pl_entry_schema_values_json_hash(
          pl_entry_schema_values_json_hash: default_pls_pl_entry_schema_values_json_hash,
          pls_count: default_pls_count)

      #puts ">>>>>>>dp_num_to_entry_chunks_data_hash: #{dp_num_to_entry_chunks_data_hash}"

      # dlp -> default_last_playlist
      dlp_entry_chunks_data_hash =
        _extract_chunks_data_from_given_last_pl_entry_schema_values_json_hash(
          last_pl_entry_schema_values_json_hash: default_pls_last_pl_entry_schema_values_json_hash)

      plif_entries_data_hash = {}.merge!(dp_num_to_entry_chunks_data_hash)
      plif_last_entry_data_hash = {}.merge!(dlp_entry_chunks_data_hash)

      h =
        _construct_plif_entries_chunks_data_hash(
          plif_entries_data_hash: plif_entries_data_hash,
          plif_last_entry_data_hash: plif_last_entry_data_hash)

      #puts ">>>>>>> h: #{h}"
      h
    end


  end
end
