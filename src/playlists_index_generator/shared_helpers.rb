module PlaylistsIndexGenerator
  module SharedHelpers
    include ::PlaylistGenerator::SharedHelpers
    include ::PlaylistsIndexGenerator::PlaylistsIndexFileHelpers

    # Note: The values for the `PLI_SCHEMA_VALUES_JSON` prefixed constants
    # below are based on contents in
    # `phone_model/nokia_220_4g_2024/playlists_index_schema_values.json`
    # file.
    #
    # pli -> playlists_index
    # pl -> playlist
    # pls -> playlists

    PLI_SCHEMA_VALUES_JSON_PLAYLIST_ENTRY_KEY = 'playlist_entry'
    PLI_SCHEMA_VALUES_JSON_LAST_PLAYLIST_ENTRY_KEY = 'last_playlist_entry'

    PLI_SCHEMA_VALUES_JSON_DEFAULT_PLAYLISTS_KEY = 'default_playlists'
    PLI_SCHEMA_VALUES_JSON_USER_CREATED_PLAYLISTS_KEY = 'user_created_playlists'

    PLI_SCHEMA_VALUES_JSON_UNMENTIONED_KEY = 'unmentioned'
    PLI_SCHEMA_VALUES_JSON_PL_ENTRY_UNMENTIONED_KEY = PLI_SCHEMA_VALUES_JSON_UNMENTIONED_KEY

    PLI_SCHEMA_VALUES_JSON_DEFAULT_PLS_COUNT_UNMENTIONED_KEY = PLI_SCHEMA_VALUES_JSON_UNMENTIONED_KEY
    PLI_SCHEMA_VALUES_JSON_DEFAULT_PLS_COUNT_MENTIONED_ARR = [ 5 ].freeze

    PLI_SCHEMA_VALUES_JSON_USER_CREATED_PLS_COUNT_GREATER_THAN_7_KEY = '> 7'
    PLI_SCHEMA_VALUES_JSON_USER_CREATED_PLS_COUNT_GREATER_THAN_OR_EQUAL_TO_13_KEY = '>= 13'
    PLI_SCHEMA_VALUES_JSON_USER_CREATED_PLS_COUNT_UNMENTIONED_KEY = PLI_SCHEMA_VALUES_JSON_UNMENTIONED_KEY
    PLI_SCHEMA_VALUES_JSON_USER_CREATED_PLS_COUNT_MENTIONED_ARR = [ 3, 4, 7 ].freeze

    private

    def _get_pl_entry_schema_values_json_hash_from_given_hash(hash)
      hash[PLI_SCHEMA_VALUES_JSON_PLAYLIST_ENTRY_KEY]
    end

    def _get_last_pl_entry_schema_values_json_hash_from_given_hash(hash)
      hash[PLI_SCHEMA_VALUES_JSON_LAST_PLAYLIST_ENTRY_KEY]
    end

    def _fetch_chunks_data_for_given_entry_num_from_given_playlist_entry_schema_values_json_hash(pl_entry_schema_values_json_hash:, entry_num_str:)
      pl_entry_num_schema_values_json_hash = pl_entry_schema_values_json_hash[entry_num_str]

      fetch_chunks_data_from_given_entry_schema_values_json_hash(
        entry_schema_values_json_hash: pl_entry_num_schema_values_json_hash
      )
    end

    def _fetch_chunks_data_from_given_last_playlist_entry_schema_values_json_hash(last_pl_entry_schema_values_json_hash:)
      fetch_chunks_data_from_given_entry_schema_values_json_hash(
        entry_schema_values_json_hash: last_pl_entry_schema_values_json_hash
      )
    end

    # `plif_entries_data_hash` name is intended to hold data for
    # all entries except last entry.
    def _construct_plif_entries_chunks_data_hash(plif_entries_data_hash:, plif_last_entry_data_hash:)
      {
        plif_entries_data_hash: plif_entries_data_hash,
        plif_last_entry_data: plif_last_entry_data_hash
      }
    end

  end
end
