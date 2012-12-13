## Schiphol

... is a smart downloader script for Ruby, with

- Progress bar for downloads, with ETA.
- Following for 301/302 redirect links.
- Automatic file type resolution w/ MIMEs.
- Automatic retries for failed downloads.

## Install

    gem install schiphol

## Usage

**Basic**

It can't get simpler.

```ruby
require 'schiphol'

Schiphol.download('http://www.url.com/path/to/file.html')
```

**Advanced**

The options shown are the default values.

```ruby
require 'schiphol'

Schiphol.download(
  'http://www.url.com/path/to/file.html',
  :download_folder => './my_downloads',
  :target_directory => '',
  :show_progress => true,
  :rectify_extensions => false,
  :max_tries => 3
)
```

## License

This software is released under the GPL.