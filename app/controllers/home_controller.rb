class HomeController < ApplicationController

  def index
  end

  # Redirect to the latest official release.

  def latest
    if latest = self.class.latest
      redirect_to "/" + latest
    else
      raise ActiveRecord::RecordNotFound
    end
  end

private

  # Find the path within `public` of the latest official release.

  def self.latest
    Dir.chdir "public" do
      Dir.glob( "files/*.tar.gz" ).map do |path|
        match = path.match( /^files\/vwf-(?<version>.*)\.tar\.gz$/ ) and
          { :path => path, :version => Semantic::Version.new( match[:version] ) }
      end .compact.reject do |hash|
        hash[:version].pre || hash[:version].build
      end .sort do |a, b|
        a[:version] <=> b[:version]
      end .map do |hash|
        hash[:path]
      end .last
    end
  end

end
