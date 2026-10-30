require 'json'
require_relative '../../src/playlist_generator'
require_relative '../../src/playlists_index_generator'


class Nokia2204gPlaylistsGenerator

  PLAYLIST_SCHEMA_JSON_FILE_PATH = 'config/playlist_schema.json'
  PLAYLIST_SCHEMA_VALUES_JSON_FILE_PATH = 'config/playlist_schema_values.json'

  PLAYLISTS_INDEX_SCHEMA_JSON_FILE_PATH = 'config/playlists_index_schema.json'
  PLAYLISTS_INDEX_SCHEMA_VALUES_JSON_FILE_PATH = 'config/playlists_index_schema_values.json'

  DEFAULT_PLAYLISTS_DATA_JSON_FILE_PATH = 'config/default_playlists_data.json'

  USER_CREATED_PLAYLIST_PATH_PREFIX_FOR_PLAYLISTS_INDEX = "E:/System/Mp3_res/"

  attr_reader :playlist_schema_json_hash, :playlist_schema_values_json_hash
  attr_reader :playlists_index_schema_json_hash, :playlists_index_schema_values_json_hash
  attr_reader :default_playlists_data_json_hash, :user_created_playlists_data_json_hash

  def initialize(user_created_playlists_data_json_file_path:)
    @playlist_schema_json_hash =
      load_json_file(
        file_path: PLAYLIST_SCHEMA_JSON_FILE_PATH)

    # Note: Deliberately not using symbol keys to avoiding converting numbers,
    # used as keys, from their symbol representation to number itself.
    @playlist_schema_values_json_hash =
      load_json_file(
        file_path: PLAYLIST_SCHEMA_VALUES_JSON_FILE_PATH,
        symbolize_names: false)

    @playlists_index_schema_json_hash =
      load_json_file(
        file_path: PLAYLISTS_INDEX_SCHEMA_JSON_FILE_PATH)

    @playlists_index_schema_values_json_hash =
      # Note: Deliberately not using symbol keys to avoiding converting numbers,
      # used as keys, from their symbol representation to number itself.
      load_json_file(
        file_path: PLAYLISTS_INDEX_SCHEMA_VALUES_JSON_FILE_PATH,
        symbolize_names: false)

    @default_playlists_data_json_hash =
      load_json_file(
        file_path: DEFAULT_PLAYLISTS_DATA_JSON_FILE_PATH)

    @user_created_playlists_data_json_hash =
      load_json_file(file_path: user_created_playlists_data_json_file_path)
  end

  def generate(debug_data: false)
    puts ">>>>>>> Starting generating playlist files"
    puts

    pl_name_arr = generate_playlists(debug_data: debug_data)

    puts
    puts ">>>>>>> Finished generating playlist files"
    puts

    puts ">>>>>>> Generated #{pl_name_arr.size} playlist files"
    puts

    puts ">>>>>>> Starting generating playlists-index file"
    puts

    generate_playlists_index(user_created_playlist_name_arr: pl_name_arr, debug_data: debug_data)

    puts
    puts ">>>>>>> Finished generating playlists-index file"
  end

  private

  def pc_root_path_to_music_collection
    @pc_root_path_to_music_collection ||=
      user_created_playlists_data_json_hash[:pc_root_path_to_music_collection]
  end

  def sd_card_root_path_to_music_collection
    @sd_card_root_path_to_music_collection ||=
      user_created_playlists_data_json_hash[:sd_card_root_path_to_music_collection]
  end

  def playlists_output_folder_path
    @playlists_output_folder_path ||=
      user_created_playlists_data_json_hash[:playlists_output_folder_path]
  end

  def playlist_data_hash_arr
    @playlist_data_hash_arr ||=
      user_created_playlists_data_json_hash[:playlists]
  end

  def playlists_index_file_output_folder_path
    playlists_index_file_output_folder_path ||=
      "#{playlists_output_folder_path}/playlists_index"
  end

  def load_json_file(file_path:, symbolize_names: true)
    begin
      data = JSON.load_file(file_path, symbolize_names: symbolize_names)

    rescue JSON::ParserError => e
      puts "Couldn't load JSON file '#{file_path}'. Error: #{e.message}"
    end
  end

  def construct_path_for_playlists_index_for_given_user_created_playlist_name(user_created_pl_name:)
    user_created_pl_path_prefix = USER_CREATED_PLAYLIST_PATH_PREFIX_FOR_PLAYLISTS_INDEX
    pl_name_extension = ::PlaylistGenerator::Main::PLF_EXTENSION

    "#{user_created_pl_path_prefix}#{user_created_pl_name}#{pl_name_extension}"
  end

  # pl -> playlist
  def generate_playlist(pl_name:, pl_music_track_paths_relative_to_pc_root_path:, debug_data: false)
    args = {
      pc_root_path_to_music_collection: pc_root_path_to_music_collection,
      sd_card_root_path_to_music_collection: sd_card_root_path_to_music_collection,
      playlist_music_track_paths_relative_to_pc_root_path: pl_music_track_paths_relative_to_pc_root_path,
      playlist_name: pl_name,
      playlists_output_folder_path: playlists_output_folder_path,
      playlist_schema_json_hash: playlist_schema_json_hash,
      playlist_schema_values_json_hash: playlist_schema_values_json_hash
    }

    generator = ::PlaylistGenerator::Main.new(**args)

    if !!debug_data
      generator.debug_data

    else
      generator.generate
    end
  end

  def generate_playlists(debug_data: false)
    pl_name_arr = []

    playlist_data_hash_arr.each do |hash|
      pl_name = hash[:name]
      # mt -> music_track
      mt_paths_relative_to_pc_root_path = hash[:music_track_paths_relative_to_pc_root_path]

      generate_playlist(
        pl_name: pl_name,
        pl_music_track_paths_relative_to_pc_root_path: mt_paths_relative_to_pc_root_path,
        debug_data: debug_data)

      pl_name_arr << pl_name
    end

    pl_name_arr
  end

  def generate_playlists_index(user_created_playlist_name_arr:, debug_data: false)
    # pls -> playlists
    default_pls_path_arr = default_playlists_data_json_hash[:default_playlist_paths]

    # pl -> playlist
    user_created_pl_path_arr = []

    user_created_playlist_name_arr.each do |uc_pl_name|
      user_created_pl_path =
        construct_path_for_playlists_index_for_given_user_created_playlist_name(
          user_created_pl_name: uc_pl_name)

      user_created_pl_path_arr << user_created_pl_path
    end

    args = {
      default_playlists_path_arr: default_pls_path_arr,
      user_created_playlists_path_arr: user_created_pl_path_arr,
      playlists_index_file_output_folder_path: playlists_index_file_output_folder_path,
      playlists_index_schema_json_hash: playlists_index_schema_json_hash,
      playlists_index_schema_values_json_hash: playlists_index_schema_values_json_hash
    }

    generator = ::PlaylistsIndexGenerator::Main.new(**args)

    if !!debug_data
      generator.debug_data

    else
      generator.generate
    end
  end
end


user_created_playlists_data_file_path = ARGV[0]

if user_created_playlists_data_file_path.nil?
  puts "<playlists_data_file_path> is required"
  exit 1
end

if !File.exist?(user_created_playlists_data_file_path)
  puts "Error: File not found at '#{user_created_playlists_data_file_path}'"
  exit 1
end


generator =
  Nokia2204gPlaylistsGenerator
    .new(user_created_playlists_data_json_file_path: user_created_playlists_data_file_path)

generator.generate(debug_data: false)



