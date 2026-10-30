module PlaylistsIndexGenerator
  module PlaylistsIndexFileHelpers
    # plif -> playlists_index_file

    PLIF_ENTRY_CHUNK_MODULE = ::PlaylistGenerator::SharedModels::Entry::Chunk

    PLIF_ENTRY_CHUNK_TYPE_NUMBER_HEX = PLIF_ENTRY_CHUNK_MODULE::TYPE_NUMBER_HEX
    PLIF_ENTRY_CHUNK_TYPE_STRING_HEX = PLIF_ENTRY_CHUNK_MODULE::TYPE_STRING_HEX

    PLIF_ENTRY_CHUNK_TYPES_FOR_WHICH_CHUNK_DATA_SHOULD_BE_EXPLICITLY_PASSED = [
      PLIF_ENTRY_CHUNK_TYPE_NUMBER_HEX,
      PLIF_ENTRY_CHUNK_TYPE_STRING_HEX
    ].freeze

    def create_plif_entry_chunk(**args)
      ::PlaylistGenerator::SharedModels::Entry::Chunk::Main.new(**args)
    end

    def create_plif_entry(entry_size:, entry_file_path:, entry_chunks_data_definition_data:, entry_chunks_data:)
      # TODO
      #puts ">>>>>>>>> entry_file_path: #{entry_file_path}"
      #puts ">>>>>>>>> entry_chunks_data: #{entry_chunks_data}"

      entry =
        ::PlaylistGenerator::SharedModels::Entry::Main
          .new(
            size: entry_size,
            entry_file_path: entry_file_path)

      chunk_module = ::PlaylistGenerator::SharedModels::Entry::Chunk

      chunk_types_for_which_chunks_data_is_applicable =

      entry_chunks_data_definition_data.each_with_index do |hash, index|
        # This is needed because in `entry_chunks_data` chunk numbers
        # uses natural sequence not Array's 0-based sequence.
        chunk_num = index + 1

        # TODO
        #puts ">>>>>>>>> chunk_num: #{chunk_num}"

        chunk_args = hash.merge(entry: entry)

        chunk_type = chunk_args[:type]

        if ( PLIF_ENTRY_CHUNK_TYPES_FOR_WHICH_CHUNK_DATA_SHOULD_BE_EXPLICITLY_PASSED.include?(chunk_type)  )
          chunk_value = entry_chunks_data[chunk_num]

          use_as_chunk_opts_key =
            case chunk_type
              when PLIF_ENTRY_CHUNK_TYPE_NUMBER_HEX
                :number

              when PLIF_ENTRY_CHUNK_TYPE_STRING_HEX
                :string

              else
                # nil
            end

          unless use_as_chunk_opts_key.nil?
            chunk_opts = { use_as_chunk_opts_key => chunk_value }
            chunk_args.merge!(opts: chunk_opts)
          end
        end

        chunk = create_plif_entry_chunk(**chunk_args)

        entry.add_chunk(chunk: chunk)
      end

      entry
    end

    def create_plif_entries(pl_file_paths:, plif_entry_size:, plif_entry_chunks_data_definition_data:, plif_entries_chunks_data:)
      entry_obj_arr = []

      pl_file_paths.each_with_index do |entry_file_path, index|
        # This is needed because in `plif_entries_chunks_data` entry numbers uses
        # natural sequence not Array's 0-based sequence.
        entry_num = index + 1

        entry_num_chunks_data = plif_entries_chunks_data[entry_num]

        # TODO
        #puts
        #puts ">>>>>>>>> entry_num: #{entry_num}"

        entry_obj_arr <<
          create_plif_entry(
            entry_size: plif_entry_size,
            entry_file_path: entry_file_path,
            entry_chunks_data_definition_data: plif_entry_chunks_data_definition_data,
            entry_chunks_data: entry_num_chunks_data)
      end

      entry_obj_arr
    end

    def print_plif_entries(entry_obj_arr:, format: true)
      entry_obj_arr.each do |entry|
        puts ">>>> playlists index file entry file_path: '#{entry.entry_file_path}'"
        puts

        #puts
        #puts ">>>> playlists index file entry chunks formatted content"
        #entry.print_formatted_chunks
        #puts

        puts ">>>> playlists index file entry content"
        puts entry.content(format: format)
        puts
        puts
      end
    end

  end
end
