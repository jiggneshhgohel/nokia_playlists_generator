module PlaylistGenerator
  module PlaylistFileHelpers
    # plf -> playlist_file

    def create_plf_entry_chunk(**args)
      ::PlaylistGenerator::SharedModels::Entry::Chunk::Main.new(**args)
    end

    def create_plf_entry(entry_size:, entry_file_path:, entry_chunks_data_definition_data:, entry_chunks_data: nil, source_file_path: nil)
      #puts ">>>>>>>>> entry_file_path: #{entry_file_path}"

      is_entry_chunks_data_available = entry_chunks_data.is_a?(Hash)

      if is_entry_chunks_data_available
        #puts ">>>>>>>>> entry_chunks_data: #{entry_chunks_data}"
      end

      entry =
        ::PlaylistGenerator::SharedModels::Entry::Main
          .new(
            size: entry_size,
            entry_file_path: entry_file_path,
            source_file_path: source_file_path)

      entry_chunks_data_definition_data.each_with_index do |hash, index|
        # This is needed because in `entry_chunks_data` chunk numbers
        # uses natural sequence not Array's 0-based sequence.
        chunk_num = index + 1

        #puts ">>>>>>>>> chunk_num: #{chunk_num}"

        chunk_args = hash.merge(entry: entry)

        chunk_type = chunk_args[:type]

        if is_entry_chunks_data_available
          if ( chunk_type == ::PlaylistGenerator::SharedModels::Entry::Chunk::TYPE_STRING_HEX )
            chunk_string_value = entry_chunks_data[chunk_num]
            chunk_opts = { string: chunk_string_value }
            chunk_args.merge!(opts: chunk_opts)
          end
        end

        chunk = create_plf_entry_chunk(**chunk_args)

        entry.add_chunk(chunk: chunk)
      end

      entry
    end

    def create_plf_entries(file_paths_data:, plf_entry_size:, plf_entry_chunks_data_definition_data:, plf_entries_chunks_data: nil)
      entry_obj_arr = []

      is_entries_chunks_data_available = plf_entries_chunks_data.is_a?(Hash)

      file_paths_data.each_with_index do |hash, index|
        # This is needed because in `plf_entries_chunks_data` entry numbers uses
        # natural sequence not Array's 0-based sequence.
        entry_num = index + 1

        entry_num_chunks_data = nil

        if is_entries_chunks_data_available
          entry_num_chunks_data = plf_entries_chunks_data[entry_num]
        end

        entry_file_path = hash[:entry_file_path]
        source_file_path = hash[:source_file_path]

        entry_obj_arr <<
          create_plf_entry(
            entry_size: plf_entry_size,
            entry_file_path: entry_file_path,
            entry_chunks_data_definition_data: plf_entry_chunks_data_definition_data,
            entry_chunks_data: entry_num_chunks_data,
            source_file_path: source_file_path)
      end

      entry_obj_arr
    end

    def print_plf_entries(entry_obj_arr:, format: true)
      entry_obj_arr.each do |entry|
        puts ">>>> playlist entry file_path: '#{entry.entry_file_path}'"
        puts

        #puts
        #puts ">>>> playlist entry chunks formatted content"
        #entry.print_formatted_chunks
        #puts

        puts ">>>> playlist entry content"
        puts entry.content(format: format)
        puts
        puts
      end
    end
  end
end
