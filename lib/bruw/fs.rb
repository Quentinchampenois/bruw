# frozen_string_literal: true

module Bruw
  class Fs
    def self.find_folder_size(path)
      return if path.empty? || path.nil?

      output = `du -sh #{path}`

      output.split
    end

    def self.meminfos(diskname)
      return if diskname.empty? || diskname.nil?

      output = `df -h | grep #{diskname}`
      ary = output.split

      return if ary.empty? || ary.nil?

      {
        filesystem: ary[0],
        size: ary[1],
        space_used: ary[2],
        space_available: ary[3],
        capacity: ary[4],
        mounted_on: ary[8]
      }
    end
  end
end
