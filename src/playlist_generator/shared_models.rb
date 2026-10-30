require_relative 'shared_helpers'

require_relative 'shared_models/entry'
require_relative 'shared_models/entry/chunk'

require_relative 'shared_models/entry/chunk/helpers'
require_relative 'shared_models/entry/chunk/chunk_type_base'
require_relative 'shared_models/entry/chunk/file_path_chars_hex'
require_relative 'shared_models/entry/chunk/file_path_length_hex'
require_relative 'shared_models/entry/chunk/file_timestamp_hex'
require_relative 'shared_models/entry/chunk/file_size_hex'
require_relative 'shared_models/entry/chunk/null_byte_hex'
require_relative 'shared_models/entry/chunk/number_hex'
require_relative 'shared_models/entry/chunk/string_hex'

require_relative 'shared_models/entry/chunk/main'
require_relative 'shared_models/entry/main'

module PlaylistGenerator
  module SharedModels

  end
end
