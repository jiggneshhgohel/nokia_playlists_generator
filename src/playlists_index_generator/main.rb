module PlaylistsIndexGenerator
  class Main
    include HeaderEntryHelpers
    include DefaultPlaylistsEntriesHelpers
    include UserCreatedPlaylistsEntriesHelpers

    # plif -> playlists_index_file
    # pls -> playlists

    PLIF_NAME = 'listinfo.data'

    REQUIRED_ARGS = [
      :default_playlists_path_arr,
      :user_created_playlists_path_arr,
      :playlists_index_file_output_folder_path,
      :playlists_index_schema_json_hash,
      :playlists_index_schema_values_json_hash
    ].freeze

    REQUIRED_ARGS.each do |arg_name_sym|
      attr_reader arg_name_sym
    end

    def initialize(**args)
      set_instance_variables_for_given_required_args!(
        required_args_name_arr: REQUIRED_ARGS, received_args: args)
    end

    def generate
      create_plif(
        plif_root_path: playlists_index_file_output_folder_path,
        plif_name: PLIF_NAME)
    end

    def debug_data
      _debug_data
    end

    private

    def entry_obj_arr
      @entry_obj_arr ||= begin
        header_entry_obj = create_header_entry
        default_pls_entry_obj_arr = create_plif_entries_for_default_playlists
        user_created_pls_entry_obj_arr = create_plif_entries_for_user_created_playlists

        entry_obj_arr = []
        entry_obj_arr << header_entry_obj
        entry_obj_arr += default_pls_entry_obj_arr
        entry_obj_arr += user_created_pls_entry_obj_arr
        entry_obj_arr
      end
    end

    def _debug_data
      # pl -> playlist
      # pls -> playlists
      file_paths = default_playlists_path_arr + user_created_playlists_path_arr

      puts "playlists index file entry file_paths"
      file_paths.each do |h|
        puts h
      end

      puts

      print_plif_entries(entry_obj_arr: entry_obj_arr, format: true)
    end

    def create_plif(plif_root_path:, plif_name:)
      file_data_arr = []

      entry_obj_arr.each do |entry|
        file_data_arr << entry.content(format: false)
      end

      plif_path = "#{plif_root_path}/#{plif_name}"

      create_binary_content_file(
        file_path: plif_path,
        file_data_arr: file_data_arr)

      puts ">>>> Successfully generated playlists-index file '#{plif_name}' at location '#{plif_root_path}'"
    end
  end
end
