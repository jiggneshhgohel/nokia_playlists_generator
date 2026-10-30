module PlaylistGenerator
  module SharedModels
    module Entry
      module Chunk
        class Main
          include ::PlaylistGenerator::SharedHelpers

          # size represents number of bytes occupied by this chunk.
          attr_reader :size, :type, :entry

          def initialize(size:, type:, entry:, opts: nil)
            @size = size
            @type = type
            @entry = entry
            @opts ||= (opts || {})
          end

          def content(format: true)
            return if chunk_type_obj.nil?

            chunk_type_obj.content(format: format)
          end

          def content_arr
            return EMPTY_ARRAY if chunk_type_obj.nil?

            chunk_type_obj.content_arr
          end

          private

          def opts
            @opts
          end

          def chunk_type_obj
            @chunk_type_obj ||= begin
              obj =
                case type
                  when TYPE_FILE_PATH_CHARS_HEX
                    FilePathCharsHex.new(chunk: self)

                  when TYPE_FILE_PATH_LENGTH_HEX
                    FilePathLengthHex.new(chunk: self)

                  when TYPE_FILE_TIMESTAMP_HEX
                    FileTimestampHex.new(chunk: self)

                  when TYPE_FILE_SIZE_HEX
                    FileSizeHex.new(chunk: self)

                  when TYPE_NULL_BYTE_HEX
                    NullByteHex.new(chunk: self)

                  when TYPE_NUMBER_HEX
                    NumberHex.new(chunk: self, number: opts[:number])

                  when TYPE_STRING_HEX
                    StringHex.new(chunk: self, string: opts[:string])

                  else
                    puts ">>>>>>> chunk type '#{type}' unhandled"
                    # Unsupported
                    nil
                end

              obj
            end
          end
        end
      end
    end
  end

end
