module PlaylistGenerator
  module SharedModels
    module Entry
      class Main
        include ::PlaylistGenerator::SharedHelpers

        # size represents number of bytes occupied by this entry in the playlist file.
        attr_reader :size

        # represents the file path on the Nokia phone's SD card.
        # This is the path which will be used as the entry's file-path
        # in the playlist file.
        attr_reader :entry_file_path

        # source_file_path represents the file path to the music-track
        # file (referred to by `entry_file_path`) on the system on which the
        # playlist-generator is run. This is optional.
        attr_reader :source_file_path

        # chunks is intended to hold the data for each chunk this entry is divided into.
        attr_reader :chunks

        def initialize(size:, entry_file_path:, source_file_path: nil)
          @size = size
          @entry_file_path = entry_file_path
          @source_file_path = source_file_path
          @chunks = []
        end

        def add_chunk(chunk:)
          chunks << chunk
        end

        def content(format: true)
          raise_error_if_entry_size_does_not_match_their_chunks_content_total_size

          chunks_content_arr = chunks.map { |c| c.content(format: format) }

          result =
            join_given_strings_arr(
              str_arr: chunks_content_arr, format: format)

          result
        end

        def print_formatted_chunks
          chunks.each do |chunk|
            puts ">>>> chunk type: '#{chunk.type}'"
            puts chunk.content
            puts
          end
        end

        private

        def raise_error_if_entry_size_does_not_match_their_chunks_content_total_size
          chunks_consolidated_content_arr = []

          chunks.each do |c|
            chunks_consolidated_content_arr += c.content_arr
          end

          chunks_content_total_size = chunks_consolidated_content_arr.size

          return if chunks_content_total_size == size

          error_msg = squish_str(%Q{
            Entry '#{entry_file_path}' content size must be #{size}.
            It is found to be #{chunks_content_total_size}.
          })

          raise_error(error_msg: error_msg)
        end
      end
    end
  end
end
