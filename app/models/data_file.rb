class DataFile < ActiveRecord::Base
  def self.save(upload)
  	rand_str = (0...8).map { (65 + rand(26)).chr }.join
    name =  rand_str + "-" + upload.original_filename
    directory = "public/tmp"
    path = File.join(directory, name)
    File.open(path, "wb") { |f| f.write(upload.read) }
    name
  end
end
