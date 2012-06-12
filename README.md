### Schiphol

... is a smart downloader script for Ruby, with

- Automatic file type resolution w/ MIMEs.
- Progress bar for downloads, with ETA.
- Downloads and extracts ZIP archives.
- Automatically retry downloads N times.

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


- Models: Mongoid + Mongo
- Views: Haml + Sinatra
- Styling: Sass + Bootstrap
- Scripts: CoffeeScript + jQuery

**Development Tools**

- Development: Shotgun + Thin
- Testing: RSpec + Travis
- Deployment: Capistrano
- Serving: Foreman + Unicorn

### Installing

**Download and install dependencies**

Clone the files to your computer and install gem dependencies:

    git clone [repo]
    cd ./closet
    bundle install

Where `[repo]` is in the format `git://github.com/username/repo.git`.

**Setting up a database**

[Install MongoDB](http://www.mongodb.org/display/DOCS/Quickstart) and start the server. Configuration options can be changed in `config/mongoid.rb`, but the default configuration should work out of the box.

### Running
  
    shotgun           # Serves app with Thin with autoreload by Shotgun.
    unicorn           # Serves app with Unicorn for production servers.
    foreman start     # Serves app with Foreman to scale app serving.

### Testing

**Testing with RSpec**

You can run all spec tests or just one file:

    rake spec         # Run all the spec tests.
    rake spec name    # Run one spec test file.

Tests will run in random order. Configuration options can be changed in the `.rspec` file.
   
**Using Travis CI**

To use Travis for automated testing, go to the Admin section of your repository, and turn on Travis in the "Service Hooks" tab. Configuration options can be changed in the `travis.yml` file.

### Deploying with Capistrano

Using Capistrano, you can deploy your app right from your public or private GitHub repo.

**Setting up a repository**

Create repo on github, then run:
  
    rm -rf .git
    git init
    git remote add origin [repo]
  
    git commit -m 'First commit.'
    git push -u origin master

Where `[repo]` is in the format `git://github.com/username/repo.git`.
Edit your `config/deploy.rb` to match your server information. 

**Deploying from repo**

    cap deploy        # Deploy to remote server.