module PlaylistGenerator
  module MusicTrackEntriesHelpers
    include ::PlaylistGenerator::SharedHelpers
    include ::PlaylistGenerator::PlaylistFileHelpers

    private

    # plf -> playlist_file
    # mt -> music_track

    def music_track_entry_schema_json_hash
      @music_track_entry_schema_json_hash ||= playlist_schema_json_hash[:music_track_entry]
    end

    def music_track_file_paths_data
      @music_track_file_paths_data ||= _create_music_track_file_paths_data
    end

    def create_music_track_entries
      file_paths_data = music_track_file_paths_data

      music_track_entry_size = music_track_entry_schema_json_hash[:size]
      music_track_entry_chunks_data_definition_data = music_track_entry_schema_json_hash[:chunks]

      music_track_entry_obj_arr =
        create_plf_entries(
          file_paths_data: file_paths_data,
          plf_entry_size: music_track_entry_size,
          plf_entry_chunks_data_definition_data: music_track_entry_chunks_data_definition_data)

      music_track_entry_obj_arr
    end

    def _create_music_track_file_paths_data
      arr = []

      playlist_music_track_paths_relative_to_pc_root_path.each do |mt_path_rltve_to_pc_root_path|
        h = {}

        pc_file_full_path_for_mt = "#{pc_root_path_to_music_collection}/#{mt_path_rltve_to_pc_root_path}"

        if File.file?(pc_file_full_path_for_mt)
          h =
            _construct_music_track_file_path_data(
              mt_path_relative_to_pc_root_path: mt_path_rltve_to_pc_root_path)

          arr << h

          next
        end

        if File.directory?(pc_file_full_path_for_mt)
          dir_path = pc_file_full_path_for_mt

          # `sort` is important. Without it entries returned are
          # in random order.
          Dir.children(dir_path).sort.select do |entry|
            use_as_pc_file_full_path_for_mt = File.join(dir_path, entry)

            if File.file?(use_as_pc_file_full_path_for_mt)
              use_as_mt_path_relative_to_pc_root_path = "#{mt_path_rltve_to_pc_root_path}/#{entry}"

              h =
                _construct_music_track_file_path_data(
                  mt_path_relative_to_pc_root_path: use_as_mt_path_relative_to_pc_root_path)

              arr << h
            end
          end

          next
        end

      end

      arr
    end

    def _construct_music_track_file_path_data(mt_path_relative_to_pc_root_path:)
      pc_file_full_path_for_mt =
       "#{pc_root_path_to_music_collection}/#{mt_path_relative_to_pc_root_path}"

      plf_entry_file_path =
        "#{sd_card_root_path_to_music_collection}/#{mt_path_relative_to_pc_root_path}"

      # Playlist file entry expects path containing Nokia phone's software
      # accepted path-separator which is forward slash.
      plf_entry_file_path =
        replace_backward_slashes_in_given_str_with_forward_slash(plf_entry_file_path)

      h = {
        source_file_path: pc_file_full_path_for_mt,
        entry_file_path: plf_entry_file_path
      }

      h
    end
  end
end
