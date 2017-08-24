require "multi_json"

module Rulers
  module Model
    class FileModel
      def initialize(filename)
        @filename = filename
        basename = File.split(filename)[-1]
        @id = File.basename(basename, ".json").to_i

        obj = File.read(filename)
        @hash = MultiJson.load(obj)
      end

      def [](name)
        @hash[name.to_s]
      end

      def []=(name, value)
        @hash[name.to_s] = value
      end

      def self.find(id)
        begin
          FileModel.new("db/quotes/#{id}.json")
        rescue
          return nil
        end
      end

      # loop until FileModel.find(id) does not exist
      # return array of matches
      def self.find_all_by_attrib(attrib, val)
        id = 1
        results = []
        loop do
          obj = FileModel.find(id)
          return results unless obj

          if obj[attrib] == val
            results << obj
          end

          id += 1
        end
      end

      def self.all
        files = Dir["db/quotes/*.json"]
        files.map { |f| FileModel.new f }
      end

      def self.create(attrs)
        hash = {}
        hash["submitter"] = attrs["submitter"] || ""
        hash["quote"] = attrs["quote"] || ""
        hash["attribution"] = attrs["attribution"] || ""

        # get all files in quotes directory
        # get filenames (e.g. id.json)
        # get highest to create new id
        files = Dir["db/quotes/*.json"]
        names = files.map { |f| File.split(f)[-1] }
        highest = names.map { |b| b.to_i }.max
        id =  highest + 1

        File.open("db/quotes/#{id}.json", "w") do |f|
          f.write <<TEMPLATE
{
  "submitter": "#{hash["submitter"]}",
  "quote": "#{hash["quote"]}",
  "attribution": "#{hash["attribution"]}"
}
TEMPLATE
        end

        FileModel.new "db/quotes/#{id}.json"
      end

      def save
        File.open(@filename, "w") do |f|
          f.write <<TEMPLATE
{
  "submitter": "#{@hash["submitter"]}",
  "quote": "#{@hash["quote"]}",
  "attribution": "#{@hash["attribution"]}"
}
TEMPLATE
        end
      end

      def self.method_missing(method, *args)
        # allow to use find_all_by_attrib with specific attribute
        if method.to_s[0..11] == "find_all_by_"
          attrib = method.to_s[12..-1]
          return find_all_by_attrib(attrib, args[0])
        end
      end
    end
  end
end
