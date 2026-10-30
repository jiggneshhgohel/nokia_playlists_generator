module PlaylistsIndexGenerator
  module PlaylistsEntriesHelpers
    include ::PlaylistsIndexGenerator::SharedHelpers

    private

    def pl_entry_schema_json_hash
      @pl_entry_schema_json_hash ||=
        playlists_index_schema_json_hash[:playlist_entry]
    end

    def last_pl_entry_schema_json_hash
      @last_pl_entry_schema_json_hash ||=
        playlists_index_schema_json_hash[:last_playlist_entry]
    end

    def _extract_chunks_data_for_given_entry_num_from_given_pl_entry_schema_values_json_hash(pl_entry_schema_values_json_hash:, entry_num_str:)
      original_chunks_data_hash =
        _fetch_chunks_data_for_given_entry_num_from_given_playlist_entry_schema_values_json_hash(
          pl_entry_schema_values_json_hash: pl_entry_schema_values_json_hash,
          entry_num_str: entry_num_str)

      h =
        transform_given_chunks_data_hash_keys_to_integer(
          chunks_data_hash: original_chunks_data_hash)

      h
    end

    def _extract_chunks_data_from_given_last_pl_entry_schema_values_json_hash(last_pl_entry_schema_values_json_hash:)
      original_chunks_data_hash =
        _fetch_chunks_data_from_given_last_playlist_entry_schema_values_json_hash(
          last_pl_entry_schema_values_json_hash: last_pl_entry_schema_values_json_hash)

      h =
        transform_given_chunks_data_hash_keys_to_integer(
          chunks_data_hash: original_chunks_data_hash)

      h
    end

    def _construct_entry_num_to_chunks_data_hash_hash(entry_num:, chunks_data_hash:)
      {
        entry_num => chunks_data_hash
      }
    end

    def _extract_chunks_data_for_given_entry_numbers_from_given_pl_entry_schema_values_json_hash(pl_entry_schema_values_json_hash:, entry_num_str_arr:)
      h = {}

      entry_num_str_arr.each do |entry_num_str|
        entry_num = entry_num_str.to_i

        #puts ">>>> entry_num: #{entry_num}"

        chunks_data_hash =
          _extract_chunks_data_for_given_entry_num_from_given_pl_entry_schema_values_json_hash(
            pl_entry_schema_values_json_hash: pl_entry_schema_values_json_hash,
            entry_num_str: entry_num_str)

        entry_num_to_chunks_data_hash_hash =
          _construct_entry_num_to_chunks_data_hash_hash(
            entry_num: entry_num,
            chunks_data_hash: chunks_data_hash)

        h.merge!(entry_num_to_chunks_data_hash_hash)
      end

      h
    end

    def _extract_chunks_data_for_pl_entries_from_given_pl_entry_schema_values_json_hash(pl_entry_schema_values_json_hash:, pls_count:)
      unmentioned_key = PLI_SCHEMA_VALUES_JSON_PL_ENTRY_UNMENTIONED_KEY

      pl_entries_keys_arr = pl_entry_schema_values_json_hash.keys
      #puts ">>>> pl_entries_keys_arr: #{pl_entries_keys_arr}"

      pl_entries_mentioned_entry_num_str_arr =
        pl_entries_keys_arr - [ unmentioned_key ]

      # Subtracting 1 because last entry is to be explicitly handled
      pls_count_range = ( 1..(pls_count - 1) )

      pl_entries_entry_num_str_arr = pls_count_range.map(&:to_s)

      pl_entries_unmentioned_entry_num_str_arr = pl_entries_entry_num_str_arr - pl_entries_mentioned_entry_num_str_arr

      #puts ">>>> pl_entries_mentioned_entry_num_str_arr: #{pl_entries_mentioned_entry_num_str_arr}"
      #puts ">>>> pl_entries_unmentioned_entry_num_str_arr: #{pl_entries_unmentioned_entry_num_str_arr}"

      #puts ">>>> pl_entry_schema_values_json_hash: #{pl_entry_schema_values_json_hash}"

      hash_1 = {}

      unless pl_entries_mentioned_entry_num_str_arr.empty?
        hash_1 =
          _extract_chunks_data_for_given_entry_numbers_from_given_pl_entry_schema_values_json_hash(
            pl_entry_schema_values_json_hash: pl_entry_schema_values_json_hash,
            entry_num_str_arr: pl_entries_mentioned_entry_num_str_arr)
      end

      hash_2 = {}

      unless pl_entries_unmentioned_entry_num_str_arr.empty?
        unmentioned_entries_chunks_data_hash =
          _extract_chunks_data_for_given_entry_num_from_given_pl_entry_schema_values_json_hash(
            pl_entry_schema_values_json_hash: pl_entry_schema_values_json_hash,
            entry_num_str: unmentioned_key)

        #puts ">>>> unmentioned_entries_chunks_data_hash: #{unmentioned_entries_chunks_data_hash}"

        pl_entries_unmentioned_entry_num_str_arr.each do |unmentioned_entry_num_str|
          unmentioned_entry_num = unmentioned_entry_num_str.to_i

          # dup because for each entry_num we intend to store a dedicated
          # copy of `unmentioned_entries_chunks_data_hash` in memory.
          use_as_chunks_data_hash = unmentioned_entries_chunks_data_hash.dup

          unmentioned_entry_num_to_chunks_data_hash_hash =
            _construct_entry_num_to_chunks_data_hash_hash(
              entry_num: unmentioned_entry_num,
              chunks_data_hash: use_as_chunks_data_hash)

          hash_2.merge!(unmentioned_entry_num_to_chunks_data_hash_hash)
        end
      end

      pl_num_to_entry_chunks_data_hash = {}

      unless hash_1.empty?
        pl_num_to_entry_chunks_data_hash.merge!(hash_1)
      end

      unless hash_2.empty?
        pl_num_to_entry_chunks_data_hash.merge!(hash_2)
      end

      #puts ">>>> pl_num_to_entry_chunks_data_hash: #{pl_num_to_entry_chunks_data_hash}"

      pl_num_to_entry_chunks_data_hash
    end

    # pl -> playlist
    # pls -> playlists
    def _create_entry_obj_arr_for_given_pls_path_arr(
          pls_path_arr:, plif_all_entries_chunks_data_for_pls:,
          use_as_plif_entry_chunks_data_definition_data_for_last_pl_path: nil,
          use_as_plif_entry_size_for_last_pl_path: nil)

      use_as_pls_path_arr =
        pls_path_arr.map do |pls_path|
          # Playlists-Index entry expects path containing Nokia phone's
          # software accepted path-separator which is forward-slash.
          replace_backward_slashes_in_given_str_with_forward_slash(pls_path)
        end

      pls_path_arr_excluding_last_path = use_as_pls_path_arr[0...-1]
      last_pl_path = use_as_pls_path_arr[-1]

      plif_entries_chunks_data =
        plif_all_entries_chunks_data_for_pls[:plif_entries_data_hash]

      plif_last_entry_chunks_data =
        plif_all_entries_chunks_data_for_pls[:plif_last_entry_data]

      pl_entry_size = pl_entry_schema_json_hash[:size]
      pl_entry_chunks_data_definition_data = pl_entry_schema_json_hash[:chunks]

      pl_entry_obj_arr =
        create_plif_entries(
          pl_file_paths: pls_path_arr_excluding_last_path,
          plif_entry_size: pl_entry_size,
          plif_entry_chunks_data_definition_data: pl_entry_chunks_data_definition_data,
          plif_entries_chunks_data: plif_entries_chunks_data)

      last_pl_entry_size = last_pl_entry_schema_json_hash[:size]
      last_pl_entry_chunks_data_definition_data = last_pl_entry_schema_json_hash[:chunks]

      use_as_plif_entry_size_for_last_pl_path ||= last_pl_entry_size
      use_as_plif_entry_chunks_data_definition_data_for_last_pl_path ||= last_pl_entry_chunks_data_definition_data

      last_pl_entry_obj =
        create_plif_entry(
          entry_size: use_as_plif_entry_size_for_last_pl_path,
          entry_file_path: last_pl_path,
          entry_chunks_data_definition_data: use_as_plif_entry_chunks_data_definition_data_for_last_pl_path,
          entry_chunks_data: plif_last_entry_chunks_data)

      entry_obj_arr = []
      entry_obj_arr += pl_entry_obj_arr
      entry_obj_arr << last_pl_entry_obj

      entry_obj_arr
    end
  end
end
