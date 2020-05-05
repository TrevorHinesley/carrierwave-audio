# CarrierWave::Audio

Simple SoX wrapper for CarrierWave uploader that allows audio file conversion and watermarking

## Installation

Add this line to your application's Gemfile:

    gem 'carrierwave-audio'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install carrierwave-audio

## Usage

Include CarrierWave::Audio into your CarrierWave uploader class:

```ruby
class AudioUploader < CarrierWave::Uploader::Base
  include CarrierWave::Audio
end
```

This gem provides two new processors for uploading audio files, `convert` and `watermark`.

### Convert

If you'd like to convert from your initially uploaded file-type to a different one, use `convert` like so:

```ruby
  version :mp3 do
    process :convert => [{output_format: :mp3}]

    def full_filename(for_file)
      "#{super.chomp(File.extname(super))}.mp3"
    end
  end
```

`process :convert` accepts a hash with one or two parameters:

```ruby
  process :convert => [{output_format:, output_options:}]
```

`output_format` - Accepts a symbol. Available options are: `:mp3` and `:wav`, default option is `:mp3`.

`output_options` - Optional. Sox options for the output file (see [ruby-sox](https://github.com/TMXCredit/ruby-sox) and the [SoX documentation](http://sox.sourceforge.net/sox.pdf)). Defaults to:

* When convert to .mp3:

```ruby
  {
    type: output_format.to_s,
    rate: 44100,
    channels: 2,
    compression: 128
  }
```

* When convert to .wav:

```ruby
  {
    type: output_format.to_s,
    rate: 44100,
    channels: 2,
    bits: 16
  }
```

### Watermark

If you'd like to add a watermark over the top of your file, use `watermark` like so:

```ruby
  version :watermarked do
    process :watermark => [{
      output_format: :mp3,
      watermark_file: "#{Rails.root}/db/watermark.mp3"
    }]

    def full_filename(for_file)
      "#{super.chomp(File.extname(super))}.mp3"
    end
  end
```

`process :watermark` accepts a hash with up to three parameters:

```ruby
  process :watermark => [{watermark_file:, output_format:, output_options:}]
```

`watermark_file` - REQUIRED. Path to where your watermarked file is stored.

VERY IMPORTANT: The watermarked file must be a 44.1k, 2-channel mp3. It needs to be a long file. It'll be truncated to fit the length of your uploaded file.

`output_format` - Accepts a symbol. The only currently available option is the default, `:mp3`.

`output_options` - Optional. Sox options for the output file (see [ruby-sox](https://github.com/TMXCredit/ruby-sox) and the [SoX documentation](http://sox.sourceforge.net/sox.pdf)). Defaults to:

```ruby
  {
    type: output_format.to_s,
    rate: 44100,
    channels: 2,
    compression: 128
  }
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
