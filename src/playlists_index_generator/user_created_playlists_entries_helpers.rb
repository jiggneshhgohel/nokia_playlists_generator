module PlaylistsIndexGenerator
  module UserCreatedPlaylistsEntriesHelpers
    include ::PlaylistsIndexGenerator::PlaylistsEntriesHelpers

    private

    # pls -> playlists

    def user_created_pls_count
      @user_created_pls_count ||= user_created_playlists_path_arr.size
    end

    def user_created_pls_schema_values_json_hash
      @user_created_pls_schema_values_json_hash ||=
        playlists_index_schema_values_json_hash[PLI_SCHEMA_VALUES_JSON_USER_CREATED_PLAYLISTS_KEY]
    end

    def user_created_pls_count_specific_schema_values_json_hash
      @user_created_pls_count_specific_schema_values_json_hash ||= begin
        # svj -> schema_values_json

        if user_created_pls_count >= 13
          uc_pls_svj_hash_key =
            PLI_SCHEMA_VALUES_JSON_USER_CREATED_PLS_COUNT_GREATER_THAN_OR_EQUAL_TO_13_KEY

        elsif user_created_pls_count > 7
          uc_pls_svj_hash_key =
            PLI_SCHEMA_VALUES_JSON_USER_CREATED_PLS_COUNT_GREATER_THAN_7_KEY

        elsif PLI_SCHEMA_VALUES_JSON_USER_CREATED_PLS_COUNT_MENTIONED_ARR.include?(user_created_pls_count)
          uc_pls_svj_hash_key = user_created_pls_count.to_s

        else
          uc_pls_svj_hash_key =
            PLI_SCHEMA_VALUES_JSON_USER_CREATED_PLS_COUNT_UNMENTIONED_KEY
        end

        #puts ">>>>>>> uc_pls_svj_hash_key: #{uc_pls_svj_hash_key}"

        uc_pls_count_specific_svj_hash =
          user_created_pls_schema_values_json_hash[uc_pls_svj_hash_key]

        uc_pls_count_specific_svj_hash
      end
    end

    def user_created_pls_pl_entry_schema_values_json_hash
      @user_created_pls_pl_entry_schema_values_json_hash ||= begin
        _get_pl_entry_schema_values_json_hash_from_given_hash(
          user_created_pls_count_specific_schema_values_json_hash)
      end
    end

    def user_created_pls_last_pl_entry_schema_values_json_hash
      @user_created_pls_last_pl_entry_schema_values_json_hash ||= begin
        _get_last_pl_entry_schema_values_json_hash_from_given_hash(
          user_created_pls_count_specific_schema_values_json_hash)
      end
    end

    def create_plif_entries_for_user_created_playlists
      all_entries_chunks_data_for_user_created_playlists =
        _create_plif_entries_chunks_data_for_user_created_playlists

      user_created_pls_entry_obj_arr =
        _create_entry_obj_arr_for_given_pls_path_arr(
          pls_path_arr: user_created_playlists_path_arr,
          plif_all_entries_chunks_data_for_pls: all_entries_chunks_data_for_user_created_playlists)

      user_created_pls_entry_obj_arr
    end

    def _create_plif_entries_chunks_data_for_user_created_playlists
      # ucp -> user_created_playlist
      ucp_num_to_entry_chunks_data_hash =
        _extract_chunks_data_for_pl_entries_from_given_pl_entry_schema_values_json_hash(
          pl_entry_schema_values_json_hash: user_created_pls_pl_entry_schema_values_json_hash,
          pls_count: user_created_pls_count)

      #puts ">>>>>>>ucp_num_to_entry_chunks_data_hash: #{ucp_num_to_entry_chunks_data_hash}"

      # uclp -> user_created_last_playlist
      uclp_entry_chunks_data_hash =
        _extract_chunks_data_from_given_last_pl_entry_schema_values_json_hash(
          last_pl_entry_schema_values_json_hash: user_created_pls_last_pl_entry_schema_values_json_hash)

      plif_entries_data_hash = {}.merge!(ucp_num_to_entry_chunks_data_hash)
      plif_last_entry_data_hash = {}.merge!(uclp_entry_chunks_data_hash)

      h =
        _construct_plif_entries_chunks_data_hash(
          plif_entries_data_hash: plif_entries_data_hash,
          plif_last_entry_data_hash: plif_last_entry_data_hash)

      #puts ">>>>>>> h: #{h}"

      h
    end

  end
end
