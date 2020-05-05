require 'carrierwave'
require 'carrierwave/audio/processor'

module CarrierWave
  module Audio
    module ClassMethods
      extend ActiveSupport::Concern

      def convert options={}
        process convert: [ options ]
      end

      def watermark options={}
        process watermark: [ options ]
      end
    end

    def convert options={}
      cache_stored_file! if !cached?

      audio_filename = Processor.convert(current_path, options)
      extension = File.extname(audio_filename).gsub(/\./, '')
      File.rename audio_filename, current_path
      self.file.instance_variable_set(:@content_type, content_type_for_extension(extension))
    end

    def watermark options={}
      cache_stored_file! if !cached?

      audio_filename = Processor.watermark(current_path, options)
      extension = File.extname(audio_filename).gsub(/\./, '')
      File.rename audio_filename, current_path
      self.file.instance_variable_set(:@content_type, content_type_for_extension(extension))
    end

    private

    def content_type_for_extension extension
      case extension.to_sym
      when :mp3
        "audio/mpeg3"
      when :wav
        "audio/vnd.wave"
      end
    end
  end
end
