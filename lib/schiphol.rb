# **Schiphol: downloader script for Ruby.**

# - Automatic file type resolution w/ MIMEs.
# - Progress bar for downloads, with ETA.
# - Downloads and extracts ZIP archives.
# - Automatically retry downloads N times.
module Schiphol
  
  #* External dependencies *#
  
  # Require net/http to download files.
  require 'net/http'
  # Require fileutils to move files around.
  require 'fileutils'
  # Require rubyzip to unzip packages.
  require 'zip/zip'
  # Require progressbar to track progress.
  require 'progressbar'
  
  #* Internal dependencies *#
  require 'schiphol/mimes'
  
  #* Default runtime options *#
  
  DefaultOptions = {
    # The main folder for downloaded files.
    :download_folder => './downloads',
    # A directory inside self.downloads in
    # which the file will be downloaded.
    # When empty, files will be downloaded
    # directly into self.downloads.
    :target_directory => '',
    # Whether to show a progress bar or not.
    :show_progress => true,
    # If set to true, downloaded files bear
    # the appropriate extension for their 
    # MIME type rather than the original
    # web file's extension.
    :rectify_extensions => false,
    # Maximal number of times to try.
    :max_tries => 3
  }
  
  #* Public static methods *#
  
  # Download a file into destination, and return
  # the path to the downloaded file. If the filename 
  # is nil, it will set the default filename to 'top'.
  def self.download(url, options = {})
    
    # Get the default options that aren't set.
    options = DefaultOptions.merge(options)
   
    # Get the folder we're downloading to.
    path = get_or_create_path(options)
    
    # Get the parsed URI from the URL.
    uri = ::URI.parse(url)
    
    # Get the filename.
    dname, fname = get_dname_fname(uri)

    # Globalize number of tries for this download.
    tries = 0
    redirects = 0
    
    # Globalize the scope of our file handler.
    file = nil
    
    begin
      
      http = Net::HTTP.new(uri.host, uri.port)
      
      # Use SSL if appropriate based on the scheme.
      http.use_ssl = true if uri.scheme == 'https'

      # Start an HTTP server to download.
      http.start do |http|
        
        # Start a GET request to the server.
        http.request_get(uri.path) do |response|
          
          # Watch for 302 redirects.
          if response.is_a?(Net::HTTPRedirection) ||
             response.code == "301"
            if redirects > 2
              raise "Too many redirects. Stopping."
            else
              redirects += 1
              return self.download(
              response['location'], options)
            end
          else
            # Check response code was OK.
            check_response_code(response.code)
          end
          
          # Get filename and rectify extension.
          if options[:rectify_extensions]
            fname = rectify_extensions(
            uri.path, response.content_type)
          end
          
          # Setup progress bar.
          if options[:show_progress]
            bar = create_bar(url, 
            response.content_length)
          end
          
          # Open a file to write to.
          file = File.open("#{path}/#{fname}", 'wb')
      
          # Write the downloaded file.
          response.read_body do |segment|
            # Increment the progress bar.
            bar.inc(segment.length) if bar
            # Write the read segment.
            file.write(segment)
          end

          # Terminate the progresss bar.
          bar.finish if bar

        end

      end

      # Return the path to the download.
      file.path.to_s
      
    # Attempt to retry N times.
    rescue Exception => error
      
      # Retry if more tries available.
      retry if (tries += 1) > options[:max_tries]
      
      # Raise exception if can't retry.
      raise "Couldn't download #{url} " +
      "(Max number of attempts reached). " +
      "Error: (#{error.message})"
      # Delete the file opened for writing.
      file.delete
    
    # Ensure the file handler is closed. 
    ensure
      file.close unless file.nil?
    end

  end
  
  #* Private methods *#
  
  private
  
  # Create a progress bar w/ length.
  def self.create_bar(url, length)
    
    unless length
      warn 'Unknown file size; ETR unknown.'
      length = 10000
    end
    
    ProgressBar.new(url, length)
    
  end
  
  # Get or create download folder.
  def self.get_or_create_path(options)
    
    # Path is download folder [+ directory].
    path = File.join(
      options[:download_folder], 
      options[:target_directory]
    )
    
    # Create path if non-existent.
    unless FileTest.directory?(path)
      FileUtils.mkdir(path)
    end
    
    path
    
  end
  
  # Parse the directory and filename
  # out of the path.
  def self.get_dname_fname(uri)
    
    split = uri.path.split('/')
    
    if split.size == 1
      return '/', split[0]
    else
      return File.join(
      *split[0..-2]), split[-1]
    end
    
  end
  
  # Rectify extension based on MIME type.
  def self.rectify_extensions(file, t)
    
    fn = File.basename(file, '.*')
    
    ext = MIMETypes[t].to_s
    
    unless ext
      raise "Don't know how to handle MIME type #{t}."
    end
      
    fn + '.' + ext
    
  end
  
  # Check that response code is OK.
  def self.check_response_code(code)
    unless code == '200'
      raise "Response code was not 200 , but #{code}."
    end
  end
  
  #* Unimplemented methods *#
  
  def self.download_and_extract(url, options = {})
    raise 'Not implemented yet.'
    unzip(download(url, options), 
    options[:destination])
  end
  
  # Decompress a ZIP archive; result will 
  # be stored in same folder as downloaded 
  # ZIP file, under a directory bearing the
  # same name as the ZIP archive.
  def self.unzip(file, options)
    
    raise 'Not implemented yet.'
    f_path = ''
    
    Zip::ZipFile.open(file) do |zip_file|
      zip_file.each do |f|
        f_path = File.join(destination, f.name)
        FileUtils.mkdir_p(File.absolute_path(File.dirname(f_path)))
        zip_file.extract(f, f_path) unless File.exist?(f_path)
      end
    end
    
    mac_remove = File.join(dest, '__MACOSX')
    if File.readable?(mac_remove)
      FileUtils.rm_rf(mac_remove)
    end
    
  end
  
end