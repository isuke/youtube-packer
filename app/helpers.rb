
class String
  URL_REG = /https?:\/\/[\w\/:%#\$&\?\(\)~\.=\+\-]+/

  def url?
    self =~ URL_REG
  end
end

module Sinatra
  module YPer
    module Helpers

      YOUTUBE_REG = /((www\.youtube\.com)|(youtu\.be))\/((watch\?v=)|(v\/)|(embed\/)?)([A-Za-z0-9_-]{11})/

      def youtube_ids(doc)
        result = []
        ['iframe[src]', 'object > embed[src]'].each do |css|
          doc.css(css).each do |d|
            tmp = YOUTUBE_REG.match(d['src'])
            result << tmp[8] unless tmp.nil? || result.include?(tmp[8])
          end
        end
        result
      end

    end
  end
end
