module PlaylistGenerator
  class Main
    include HeaderEntryHelpers
    include MusicTrackEntriesHelpers

    # pl -> playlist
    # plf -> playlist_file

    PLF_EXTENSION = '.lst'

    REQUIRED_ARGS = [
      :pc_root_path_to_music_collection,
      :sd_card_root_path_to_music_collection,
      :playlist_music_track_paths_relative_to_pc_root_path,
      :playlist_name,
      :playlists_output_folder_path,
      :playlist_schema_json_hash,
      :playlist_schema_values_json_hash
    ].freeze

    REQUIRED_ARGS.each do |arg_name_sym|
      attr_reader arg_name_sym
    end

    def initialize(**args)
      set_instance_variables_for_given_required_args!(
        required_args_name_arr: REQUIRED_ARGS, received_args: args)
    end

    def generate
      plf_name_with_extension = "#{playlist_name}#{PLF_EXTENSION}"

      create_plf(
        plf_root_path: playlists_output_folder_path,
        plf_name: plf_name_with_extension)
    end

    def debug_data
      _debug_data
    end

    private

    def entry_obj_arr
      @entry_obj_arr ||= begin
        header_entry_obj = create_header_entry
        music_track_entry_obj_arr = create_music_track_entries

        entry_obj_arr = []
        entry_obj_arr << header_entry_obj
        entry_obj_arr += music_track_entry_obj_arr
        entry_obj_arr
      end
    end

    def _debug_data
      file_paths_data = music_track_file_paths_data

      puts "playlist file_paths_data"
      file_paths_data.each do |h|
        puts h
      end

      puts

      print_plf_entries(entry_obj_arr: entry_obj_arr, format: true)
    end

    def create_plf(plf_root_path:, plf_name:)
      file_data_arr = []

      entry_obj_arr.each do |entry|
        file_data_arr << entry.content(format: false)
      end

      plf_path = "#{playlists_output_folder_path}/#{plf_name}"

      create_binary_content_file(
        file_path: plf_path,
        file_data_arr: file_data_arr)

      puts ">>>> Successfully generated playlist-file '#{plf_name}' at location '#{plf_root_path}'"
    end

  end
end
