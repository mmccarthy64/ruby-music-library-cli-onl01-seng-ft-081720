class Song
  attr_accessor :name, :artist, :genre
  
  extend Concerns::Findable
  
  @@all = []
  
  def initialize(name, artist = 'nil', genre = 'nil')
    @name = name
    self.artist =(artist) if artist != 'nil'
    self.genre =(genre) if genre != 'nil'
  end
  
  def self.all
    @@all
  end
  
  def save
    @@all << self
  end
  
  def self.destroy_all
    @@all.clear
  end
  
  def self.create(name)
    self.new(name).tap{|n| n.save}
  end
  
  # def find_by_name(name)
  #   @@all.find {|song| song.name == name}
  # end
  
  # def find_or_create_by_name(name)
  #   self.find(name) ? self.find(name) : self.create(name)
  # end
  
  def artist=(artist)
    @artist = artist
    artist.add_song(self)
  end
  
  def genre=(genre)
    @genre = genre
    if genre.songs.include?(self)
      nil
    else
      genre.songs << self
    end
  end
  
  def self.new_from_filename(filename)
    array = filename.split(" - ")
    
    artist_name = array[0]
    artist = Artist.find_or_create_by_name(artist_name)
    
    title  = array[1]
    
    genre_name = array[2].chomp(".mp3")
    genre = Genre.find_or_create_by_name(genre_name)
    
    self.new(title, artist, genre)

  end
  
  def self.create_from_filename(filename)
    self.new_from_filename(filename).save
  end
  
  
end