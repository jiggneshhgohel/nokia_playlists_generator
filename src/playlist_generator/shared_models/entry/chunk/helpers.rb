module PlaylistGenerator
  module SharedModels
    module Entry
      module Chunk
        module Helpers

          def validate_chunk_entry_has_source_file_path_set!(chunk:)
            source_fp = chunk.entry.source_file_path

            if source_fp.nil?
              raise_error(error_msg: "source_file_path is required to be set in the entry to which this chunk belongs to!")
            end

            source_fp
          end
        end
      end
    end
  end
end
