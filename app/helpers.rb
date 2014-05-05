module Sinatra
  module YPer
    module Helpers

      def youtube_ids(doc)
        result = []
        [{css: 'iframe'        , attr: 'src'},
         {css: 'object > param', attr: 'value'}].each do |hash|
          youtube_ids0(doc, hash[:css], hash[:attr]) do |id|
            result << id unless result.include?(id)
          end
        end
        result
      end

      private

      def youtube_ids0(doc, css, attr)
        doc.css(css).each do |d|
          d[attr].scan(/^.*((youtu.be\/)|(v\/)|(\/u\/\w\/)|(embed\/)|(watch\?))\??v?=?([^#\&\?]*).*/) do |m|
            yield m[6]
          end
        end
      end

    end
  end
end
